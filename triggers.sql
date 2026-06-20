-- **** ATUALIZAÇÃO STATUS DE UM EXEMPLAR: PÓS EMPRÉSTIMO *****

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

-- **** ATUALIZAÇÃO STATUS DE UM EXEMPLAR: PÓS DEVOLUÇÃO *****

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
