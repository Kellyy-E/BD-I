-- ********CONSULTAS INTERSEÇÃO, UNIAO, SUBTRACAO*********

#1 -Todos os participantes de eventos(internos e externos)
SELECT
    ui.cpf, ui.nome_completo, 'Interno' AS tipo_participante
FROM usuario_interno ui 
INNER JOIN inscricao_evento ie ON ui.cpf = ie.cpf_participante

UNION

SELECT
    pe.cpf, pe.nome_completo, 'Externo' AS tipo_participante
FROM participante_external pe 
INNER JOIN inscricao_evento ie ON pe.cpf = ie.cpf_participante

ORDER BY tipo_participante, nome_completo;

#2 - Usuarios internos que estao inscritos em pelo menos um evento
SELECT cpf
FROM usuario_interno

INTERSECT

SELECT cpf_participante
FROM inscricao_evento

ORDER BY cpf;

#3 - úsuarios que nunca se inscreveram em nenhum evento
SELECT cpf, nome_completo
FROM usuario_interno

EXCEPT

SELECT ui.cpf, ui.nome_completo
FROM usuario_interno ui 
INNER JOIN inscricao_evento ie ON ui.cpf = ie.cpf_participante

ORDER BY nome_completo;

#4 - CPFs de todos que tem vinculo ativo: emprestimo em aberto ou Inscrição em eventos futuros
SELECT
    cpf_usuario AS cpf, 'Emppestimo em aberto' AS vinculo
FROM emprestimo
WHERE data_efetiva_devolucao IS NULL

UNION

SELECT ie.cpf_participante AS cpf, 'Inscricao em evento futuro' AS vinculo
FROM inscricao_evento ie 
INNER JOIN evento ev ON ie.id_evento = ev.id_evento
WHERE ev.data_realizacao >= CURRENT_DATE

ORDER BY cpf, vinculo;