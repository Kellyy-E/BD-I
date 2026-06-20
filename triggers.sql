--**************
-- **** 1 - ATUALIZAÇÃO STATUS DE UM EXEMPLAR: PÓS EMPRÉSTIMO *****
--**************

--FUNÇÃO
CREATE OR REPLACE FUNCTION atualizar_status_exemplar()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE exemplar_fisico
    SET status_disponibilidade = 'Emprestado'
    WHERE id_exemplar = NEW.id_exemplar;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER
CREATE TRIGGER trg_saida_exemplar
AFTER INSERT ON emprestimo
FOR EACH ROW
EXECUTE FUNCTION atualizar_status_exemplar();

--**************
-- **** 2 - ATUALIZAÇÃO STATUS DE UM EXEMPLAR: PÓS DEVOLUÇÃO *****
--**************

-- FUNÇÃO
CREATE OR REPLACE FUNCTION registrar_devolucao_exemplar()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.data_efetiva_devolucao IS NOT NULL AND OLD.data_efetiva_devolucao IS NULL THEN
        UPDATE exemplar_fisico
        SET status_disponibilidade = 'Disponível'
        WHERE id_exemplar = NEW.id_exemplar;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER
CREATE TRIGGER trg_entrada_exemplar
AFTER UPDATE ON emprestimo
FOR EACH ROW
EXECUTE FUNCTION registrar_devolucao_exemplar();


--**************
-- **** 3 - BLOQUEIO DE EMPRESTIMO DE EXEMPLAR EMPRESTADO *****
--**************

-- FUNCAO
CREATE OR REPLACE FUNCTION checar_disponibilidade_exemplar()
RETURNS TRIGGER AS $$
DECLARE
    status_atual VARCHAR(20);
BEGIN
    SELECT status_disponibilidade INTO status_atual
    FROM exemplar_fisico
    WHERE id_exemplar = NEW.id_exemplar;
    
    IF status_atual != 'Disponível' THEN
        RAISE EXCEPTION 'Erro: O exemplar % não pode ser emprestado. O status atual é: %', NEW.id_exemplar, status_atual;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER 
CREATE TRIGGER trg_checar_disponibilidade
BEFORE INSERT ON emprestimo
FOR EACH ROW
EXECUTE FUNCTION checar_disponibilidade_exemplar();


--**************
-- **** 4 - ATUALIZAÇÃO DA MULTA POR ATRASO *****
--**************

-- FUNÇÃO
CREATE OR REPLACE FUNCTION calcular_multa_atraso()
RETURNS TRIGGER AS $$
DECLARE
    dias_atraso INT;
    valor_diaria NUMERIC := 1.00; 
BEGIN
    IF NEW.data_efetiva_devolucao IS NOT NULL AND OLD.data_efetiva_devolucao IS NULL THEN
        
        IF NEW.data_efetiva_devolucao > NEW.data_prevista_devolucao THEN
            dias_atraso := NEW.data_efetiva_devolucao - NEW.data_prevista_devolucao;
            
            NEW.multa_atraso := dias_atraso * valor_diaria;
        ELSE
            NEW.multa_atraso := 0.00;
        END IF;
        
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER
CREATE TRIGGER trg_calcular_multa
BEFORE UPDATE ON emprestimo
FOR EACH ROW
EXECUTE FUNCTION calcular_multa_atraso();

--**************
-- **** 5 - PRECAUÇÃO CONTRA "CHOQUE" DE EVENTOS *****
--**************

-- FUNÇÃO
CREATE OR REPLACE FUNCTION checar_conflito_horario_evento()
RETURNS TRIGGER AS $$
DECLARE
    quantidade_conflitos INT;
BEGIN
    SELECT COUNT(*) INTO quantidade_conflitos
    FROM evento
    WHERE id_local = NEW.id_local 
      AND data_realizacao = NEW.data_realizacao
      AND (NEW.horario_inicio < horario_fim AND NEW.horario_fim > horario_inicio)
      AND id_evento != COALESCE(NEW.id_evento, -1);

    IF quantidade_conflitos > 0 THEN
        RAISE EXCEPTION 'Erro de Agendamento: Já existe um evento reservado para o local % na data % neste intervalo de horário.', NEW.id_local, NEW.data_realizacao;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER
CREATE TRIGGER trg_evitar_conflito_evento
BEFORE INSERT OR UPDATE ON evento
FOR EACH ROW
EXECUTE FUNCTION checar_conflito_horario_evento();