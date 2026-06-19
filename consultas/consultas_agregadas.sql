-- ********CONSULTAS AGREGADAS*********

#1 - Total de empréstimos e multa acumulada por úsuario

SELECT
    ui.nome_completo,
    COUNT(e.id_emprestimo) AS total_emprestimos,
    SUM(e.multa_atraso) AS multa_total,
    ROUND(AVG(e.multa_atraso), 2) AS multa_media
FROM usuario_interno ui
LEFT JOIN emprestimo e ON ui.cpf = e.cpf_usuario
GROUP BY ui.cpf, ui.nome_completo
ORDER BY multa_total DESC;

#2 - Número de obras por autor e idioma

SELECT 
    a.nome_autor AS autor, o.idioma AS idioma,
    COUNT(oa.id_obra) AS total_obras
FROM autor a  
JOIN obra_autor oa ON a.id_author = oa.id_author
JOIN obra o ON oa.id_obra = o.id_obra
GROUP BY a.nome_autor, o.idioma
ORDER BY autor, idioma;

#3 - Obras com mais de um autor cadastrado na tabela obra_autor
SELECT
    o.titulo, o.editora, o.ano_publicacao,
    COUNT(oa.id_author) AS total_autores
FROM obra o 
INNER JOIN obra_autor oa ON o.id_obra = oa.id_obra
GROUP BY o.id_obra, o.titulo, o.editora, o.ano_publicacao
HAVING COUNT(oa.id_author) > 1
ORDER BY total_autores DESC;

#4 - total de inscrições por evento e tipo, como nome do local
SELECT
    ev.id_evento, ev.tipo_evento, ev.tema_abordado, le.predio,
    COUNT(ie.cpf_participante) AS total_inscritos
FROM evento ev
INNER JOIN local_evento le ON ev.id_local = le.id_local
LEFT JOIN inscricao_evento ie ON ev.id_evento = ie.id_evento
GROUP BY ev.id_evento, ev.tipo_evento, ev.tema_abordado, le.predio
ORDER BY total_inscritos DESC;

#5 - Quantidade de exemplares fisicos por obra e por status de disponibilidade
SELECT
    o.titulo, ef.status_disponibilidade,
    COUNT(ef.id_exemplar) AS qtd_exemplares
FROM obra o 
INNER JOIN exemplar_fisico ef ON o.id_obra = ef.id_obra
GROUP BY o.titulo, ef.status_disponibilidade
ORDER BY o.titulo, ef.status_disponibilidade;

#6 -apacidade total e media dos locais de evento agrupados por predio
SELECT
    le.predio,
    COUNT(le.id_local)                     AS total_salas,
    SUM(le.capacidade_maxima)              AS capacidade_total,
    ROUND(AVG(le.capacidade_maxima), 0)    AS capacidade_media,
    MAX(le.capacidade_maxima)              AS maior_capacidade,
    MIN(le.capacidade_maxima)              AS menor_capacidade
FROM local_evento le
GROUP BY le.predio
ORDER BY capacidade_total DESC;

#7 -Quantidade de eventos por tipo e publico-alvo, apenas tipos com mais de um evento
SELECT
    ev.tipo_evento,ev.publico_alvo,
    COUNT(ev.id_evento)     AS total_eventos,
    MIN(ev.data_realizacao) AS primeiro_evento,
    MAX(ev.data_realizacao) AS ultimo_evento
FROM evento ev
GROUP BY ev.tipo_evento, ev.publico_alvo
HAVING COUNT(ev.id_evento) >= 1
ORDER BY total_eventos DESC, ev.tipo_evento;