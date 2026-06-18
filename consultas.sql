-- 1. Testar o Módulo de Usuários e Cargos
SELECT * FROM cargo_funcionario;
SELECT * FROM usuario_interno;
SELECT * FROM aluno;
SELECT * FROM professor;
SELECT * FROM funcionario;
SELECT * FROM participante_external;

-- 2. Testar o Módulo de Catálogo e Autores
SELECT * FROM obra;
SELECT * FROM ebook;
SELECT * FROM exemplar_fisico;
SELECT * FROM autor;
SELECT * FROM obra_autor;

-- 3. Testar o Módulo de Empréstimos e Dispositivos
SELECT * FROM dispositivo_acesso;
SELECT * FROM emprestimo;

-- 4. Testar o Módulo de Infraestrutura e Eventos
SELECT * FROM local_evento;
SELECT * FROM evento;
SELECT * FROM inscricao_evento;