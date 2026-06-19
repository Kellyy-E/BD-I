-- ********JUNÇÃO INTERNA*********

-- Histórico de Empréstimos Ativos de Alunos
SELECT 
    ui.nome_completo AS nome_aluno,
    al.numero_matricula,
    ob.titulo AS titulo_livro,
    emp.data_retirada,
    emp.data_prevista_devolucao
FROM usuario_interno ui
INNER JOIN aluno al ON ui.cpf = al.cpf
INNER JOIN emprestimo emp ON ui.cpf = emp.cpf_usuario
INNER JOIN exemplar_fisico exf ON emp.id_exemplar = exf.id_exemplar
INNER JOIN obra ob ON exf.id_obra = ob.id_obra
WHERE emp.data_efetiva_devolucao IS NULL;

-- Nomes de Autores das Obras em Processo de Manutenção Física
SELECT 
    au.nome_autor,
    ob.titulo AS titulo_obra,
    exf.id_exemplar,
    exf.localizacao_biblioteca
FROM autor au
INNER JOIN obra_autor oa ON au.id_author = oa.id_author
INNER JOIN obra ob ON oa.id_obra = ob.id_obra
INNER JOIN exemplar_fisico exf ON ob.id_obra = exf.id_obra
WHERE exf.status_disponibilidade = 'Em Manutenção';

-- Professores Inscritos em Palestras da Instituição
SELECT 
    ui.nome_completo AS nome_professor,
    prof.siape,
    ev.tema_abordado AS tema_palestra,
    ev.data_realizacao
FROM usuario_interno ui
INNER JOIN professor prof ON ui.cpf = prof.cpf
INNER JOIN inscricao_evento ie ON ui.cpf = ie.cpf_participante
INNER JOIN evento ev ON ie.id_evento = ev.id_evento
WHERE ev.tipo_evento = 'Palestra';


-- Escala de Funcionários com seus Respectivos Cargos e Turnos
SELECT 
    ui.nome_completo AS nome_funcionario,
    cf.nome_cargo,
    func.turno AS turno_trabalho
FROM usuario_interno ui
INNER JOIN funcionario func ON ui.cpf = func.cpf
INNER JOIN cargo_funcionario cf ON func.id_cargo = cf.id_cargo;