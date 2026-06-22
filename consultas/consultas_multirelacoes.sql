-- ******** CONSULTAS COM DADOS DE PELO MENOS 3 RELAÇÕES ********

-- 1. Locais de evento e os temas das palestras/clubes neles realizados, com os autores associados ao tema
SELECT 
    le.predio,
    le.bloco,
    ev.tipo_evento,
    ev.tema_abordado,
    ui.nome_completo AS nome_inscrito
FROM local_evento le
INNER JOIN evento ev ON le.id_local = ev.id_local
INNER JOIN inscricao_evento ie ON ev.id_evento = ie.id_evento
INNER JOIN usuario_interno ui ON ie.cpf_participante = ui.cpf;

-- 2. Exemplares físicos com obra e autor, mostrando o que está disponível no acervo
SELECT 
    ob.titulo AS titulo_obra,
    au.nome_autor,
    exf.localizacao_biblioteca,
    exf.status_disponibilidade
FROM obra ob
INNER JOIN obra_autor oa ON ob.id_obra = oa.id_obra
INNER JOIN autor au ON oa.id_autor = au.id_autor
INNER JOIN exemplar_fisico exf ON ob.id_obra = exf.id_obra;

-- 3. Funcionários, seus cargos, e os equipamentos que utilizaram (histórico de uso de dispositivos)
SELECT 
    ui.nome_completo AS nome_funcionario,
    cf.nome_cargo,
    da.tipo_dispositivo,
    ud.horario_inicio,
    ud.horario_fim
FROM usuario_interno ui
INNER JOIN funcionario func ON ui.cpf = func.cpf
INNER JOIN cargo_funcionario cf ON func.id_cargo = cf.id_cargo
INNER JOIN uso_dispositivo ud ON ui.cpf = ud.cpf_usuario
INNER JOIN dispositivo da ON ud.id_dispositivo = da.id_dispositivo;


