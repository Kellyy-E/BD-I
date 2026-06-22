-- 1. Usuários inscritos em TODAS as Palestras

SELECT ui.cpf, ui.nome_completo
FROM usuario_interno ui
WHERE NOT EXISTS (
    SELECT 1
    FROM evento e
    WHERE e.tipo_evento = 'Palestra'
    AND NOT EXISTS (
        SELECT 1
        FROM inscricao_evento ie
        WHERE ie.id_evento = e.id_evento
        AND ie.cpf_participante = ui.cpf
    )
);

-- 2. Usuários que pegaram empréstimo de TODOS os exemplares da obra "Os 3 Porquinhos Bonitos"

SELECT ui.cpf, ui.nome_completo
FROM usuario_interno ui
WHERE NOT EXISTS (
    SELECT 1
    FROM exemplar_fisico ef
    WHERE ef.id_obra = 1
    AND NOT EXISTS (
        SELECT 1
        FROM emprestimo emp
        WHERE emp.id_exemplar = ef.id_exemplar
        AND emp.cpf_usuario = ui.cpf
    )
);