-- ********JUNÇÃO INTERNA*********

-- 1. Histórico de Empréstimos Ativos de Alunos
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

-- 2. Nomes de Autores das Obras em Processo de Manutenção Física
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

-- 3. Professores Inscritos em Palestras da Instituição
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


-- 4. Escala de Funcionários com seus Respectivos Cargos e Turnos
SELECT 
    ui.nome_completo AS nome_funcionario,
    cf.nome_cargo,
    func.turno AS turno_trabalho
FROM usuario_interno ui
INNER JOIN funcionario func ON ui.cpf = func.cpf
INNER JOIN cargo_funcionario cf ON func.id_cargo = cf.id_cargo;

--************************************
-- ******** JUNÇÃO EXTERNA A ESQUERDA ********

-- 1. Todos os utilizadores cadastrados e os seus empréstimos (mesmo quem nunca requisitou um livro)
SELECT 
    ui.nome_completo AS nome_utilizador,
    ui.email_institucional,
    emp.id_exemplar AS codigo_livro_emprestado,
    emp.data_retirada
FROM usuario_interno ui
LEFT JOIN emprestimo emp ON ui.cpf = emp.cpf_usuario;

-- 2. Catálogo completo de obras e a sua disponibilidade virtual (E-books)
SELECT 
    ob.titulo AS titulo_da_obra,
    ob.ano_publicacao,
    eb.link_acesso AS link_do_ebook
FROM obra ob
LEFT JOIN ebook eb ON ob.id_obra = eb.id_obra;

-- 3. Mapeamento de todos os espaços da universidade e os eventos lá agendados
SELECT 
    le.predio,
    le.bloco,
    le.capacidade_maxima,
    ev.tema_abordado AS tema_do_evento,
    ev.data_realizacao
FROM local_evento le
LEFT JOIN evento ev ON le.id_local = ev.id_local;

-- 4. Todos os dispositivos e o respectivo histórico de utilização

SELECT 
    disp.id_dispositivo,
    disp.tipo_dispositivo,
    ud.horario_inicio AS acesso_inicio,
    ud.horario_fim AS acesso_fim,
    ud.cpf_usuario AS cpf_do_aluno
FROM dispositivo_acesso disp
LEFT JOIN uso_dispositivo ud ON disp.id_dispositivo = ud.id_dispositivo;

--************************************
[-- ******** JUNÇÃO EXTERNA A DIREITA *********

-- 1. Todos os exemplares físicos e o seu histórico de saídas
SELECT 
    emp.data_retirada,
    emp.data_prevista_devolucao,
    exf.id_exemplar,
    exf.localizacao_biblioteca,
    exf.status_disponibilidade
FROM emprestimo emp
RIGHT JOIN exemplar_fisico exf ON emp.id_exemplar = exf.id_exemplar;


-- 2. Todos os Autores cadastrados e as obras associadas a eles
SELECT 
    ob.titulo AS titulo_obra,
    ob.ano_publicacao,
    au.nome_autor
FROM obra ob
INNER JOIN obra_autor oa ON ob.id_obra = oa.id_obra
RIGHT JOIN autor au ON oa.id_author = au.id_author;

-- 3. Todos os Convidados Externos e as suas inscrições confirmadas
SELECT 
    ie.id_evento,
    ie.data_inscricao,
    pe.nome_completo AS nome_visitante,
    pe.instituicao_origem
FROM inscricao_evento ie
RIGHT JOIN participante_external pe ON ie.cpf_participante = pe.cpf;

-- 4. Quadro de Eventos Cadastrados e o Volume de Inscrições (Incluindo eventos vazios)
SELECT 
    ev.tema_abordado AS tema_do_evento,
    ev.tipo_evento,
    ev.data_realizacao,
    ie.cpf_participante AS cpf_do_inscrito,
    ie.data_inscricao
FROM inscricao_evento ie
RIGHT JOIN evento ev ON ie.id_evento = ev.id_evento;

]
-- ********JUNÇÃO EXTERNA TOTAL*********

-- 1 - Obra e seus exemplares fisicos, inclusive obras sem exemplares e exemplares órfaos

SELECT
    o.titulo, o.editora, ef.id_exemplar, ef.localizacao_biblioteca,
    ef.status_disponibilidade
FROM obra o 
FULL OUTER JOIN exemplar_fisico ef ON o.id_obra = ef.id_obra
ORDER BY o.titulo NULLS LAST, ef.id_exemplar;

#2 - Eventos e suas inscrições inclusive eventos em inscritos
SELECT 
    ev.id_evento,
    ev.tipo_evento,
    ev.tema_abordado,
    ev.data_realizacao,
    ie.cpf_participante,
    ie.data_inscricao
FROM evento ev 
FULL OUTER JOIN inscricao_evento ie ON ev.id_evento = ie.id_evento
ORDER BY ev.id_evento NULLS LAST, ie.data_inscricao;

#3 - usuários internos e inscrições em evento identificando quem nunca se inscreveu
SELECT
    ui.nome_completo,
    ie.id_evento,
    ie.data_inscricao,
    CASE 
        WHEN ui.cpf IS NULL THEN 'Participante Externo'
        WHEN ie.id_evento IS NULL THEN 'Nunca se inscreveu'
        ELSE  'Inscrito'
    END AS situacao
FROM usuario_interno ui 
FULL OUTER JOIN inscricao_evento ie ON ui.cpf = ie.cpf_participante
ORDER BY situacao, ui.nome_completo NULLS LAST;

#4 - locais de evento e os eventos realizados inclusive locais sem evento agendado
SELECT
    le.predio, le.andar, le.bloco,
    le.capacidade_maxima, ev.tipo_evento, ev.data_realizacao, ev.publico_alvo
FROM local_evento le 
FULL OUTER JOIN evento ev ON le.id_local = ev.id_local
ORDER BY le.predio NULLS LAST, ev.data_realizacao;