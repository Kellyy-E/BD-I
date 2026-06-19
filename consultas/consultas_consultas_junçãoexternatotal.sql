-- ********JUNÇÃO EXTERNA TOTAL*********

#1 - Obra e seus exemplares fisicos, inclusive obras sem exemplares e exemplares órfaos

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