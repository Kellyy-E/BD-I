TRUNCATE TABLE 
    usuario_interno, 
    autor, 
    obra, 
    local_evento, 
    evento,
    cargo_funcionario,
    participante_externo,
    inscricao_evento,
    dispositivo
RESTART IDENTITY CASCADE;

INSERT INTO cargo_funcionario (nome_cargo) VALUES 
('Atendimento'),
('Catalogação'),
('Digitalização');

INSERT INTO usuario_interno (cpf, nome_completo, email_institucional, telefone, endereco) VALUES
('11122233344', 'Carlos Augusto Silva', 'carlos.aluno@ufpi.edu.br', '89999112233', 'Rua 24 de Janeiro, 120 - Centro'),
('22233344455', 'Mariana Costa Sousa', 'mariana.aluna@ufpi.edu.br', '89999223344', 'Av. Nossa Senhora de Fátima, 450'),
('33344455566', 'Bruna Oliveira Lima', 'bruna.aluna@ufpi.edu.br', '89999334455', 'Rua Monsenhor Hipólito, 890'),
('44455566677', 'Profa. Ana Maria Sousa', 'anamaria.prof@ufpi.edu.br', '89999445566', 'Bairro Canto da Várzea'),
('55566677788', 'Prof. Raimundo Nonato', 'rnonato.prof@ufpi.edu.br', '89999556677', 'Rua Teresina, 32'),
('66677788899', 'Francisco José Costa', 'francisco.func@ufpi.edu.br', '89999667788', 'Bairro Junco'),
('77788899900', 'Antônia Alves Rocha', 'antonia.func@ufpi.edu.br', '89999778899', 'Bairro Aerolândia');


INSERT INTO aluno (cpf, numero_matricula) VALUES 
('11122233344', '2023901234'),
('22233344455', '2024905678'),
('33344455566', '2025901122');

INSERT INTO professor (cpf, siape) VALUES 
('44455566677', '1004321'),
('55566677788', '2008765');

INSERT INTO funcionario (cpf, turno, id_cargo) VALUES 
('66677788899', 'Manhã', 1), 
('77788899900', 'Tarde', 2); 

INSERT INTO participante_externo (cpf, chave_convite_unica, nome_completo, email_contato, instituicao_origem) VALUES
('88899900011', 'CONV001', 'Marcos Viana Oliveira', 'marcos.viana@gmail.com', 'IFPI Campus Picos'),
('99900011122', 'CONV002', 'Juliana de Castro Reis', 'ju.castro@hotmail.com', 'UESPI');


INSERT INTO autor (id_autor, nome_autor) VALUES 
(1, 'José Silva'),
(2, 'Maria Fernandes'),
(3, 'Carlos Drummond Fictício'),
(4, 'Ana Souza');

INSERT INTO obra (id_obra, titulo, editora, ano_publicacao, idioma) VALUES 
(1, 'Os 3 porquinhos bonitos', 'Editora Floresta', 2024, 'Português'),
(2, 'A Revolta dos Dados Nulos', 'Livros para Ler', 2023, 'Português'),
(3, 'O Mistério da Chave Estrangeira', 'Editora Relacional', 2020, 'Português'),
(4, 'O Senhor dos Anéis de Repetição', 'Livros para Ler', 2022, 'Português');

INSERT INTO obra_autor (id_obra, id_autor) VALUES 
(1, 1), 
(2, 2), 
(3, 3), 
(4, 4), 
(4, 1); 


INSERT INTO ebook (id_obra, link_acesso) VALUES
(1, 'https://biblioteca.ufpi.br/ebooks'),
(2, 'https://biblioteca.ufpi.br/ebooks');



INSERT INTO exemplar_fisico (id_obra, localizacao_biblioteca, status_disponibilidade) VALUES
(1, 'Estante 04, Prateleira B', 'Disponível'),
(1, 'Estante 04, Prateleira B', 'Disponível'), 
(1, 'Estante 04, Prateleira C', 'Disponível'),
(3, 'Estante 02, Prateleira A', 'Disponível'),
(4, 'Estante 01, Prateleira D', 'Em Manutenção');


INSERT INTO dispositivo (tipo_dispositivo, sistema_operacional, status_disponibilidade) VALUES
('Computador', 'Ubuntu Linux 24.04', 'Disponível'),
('Computador', 'Ubuntu Linux 24.04', 'Em Manutenção'),
('Notebook', 'Windows 11', 'Em Uso');

INSERT INTO uso_dispositivo (id_dispositivo, cpf_usuario, horario_inicio, horario_fim) VALUES
(1, '11122233344', '2026-06-18 08:00:00', '2026-06-18 10:00:00'), 
(1, '22233344455', '2026-06-15 08:00:00', '2026-06-15 10:00:00'), 
(2, '22233344455', '2026-06-18 14:00:00', NULL),
(3, '66677788899','2026-06-15 08:00:00', '2026-06-15 10:00:00');         

INSERT INTO emprestimo (cpf_usuario, id_exemplar, data_retirada, data_prevista_devolucao, data_efetiva_devolucao, multa_atraso) VALUES
('11122233344', 1, '2026-05-10', '2026-05-24', '2026-05-20', NULL), 
('11122233344', 2, '2026-06-01', '2026-06-15', '2026-06-15', NULL),
('11122233344', 3, '2026-06-01', '2026-06-15', NULL, NULL),        
('22233344455', 4, '2026-05-01', '2026-05-15', '2026-05-11', NULL),
('22233344455', 1, '2026-02-10', '2026-02-24', NULL, NULL);

-- Atualizando emprestimo que terá multa
UPDATE emprestimo 
SET data_efetiva_devolucao = '2026-02-26'
WHERE id_emprestimo = 5;

INSERT INTO local_evento (capacidade_maxima, predio, andar, bloco) VALUES
(50, 'Bloco de Sistemas', '1º Andar', 'Auditório B'),
(30, 'Biblioteca Central', 'Térreo', 'Sala de Estudos 01'),
(25, 'Biblioteca Central', 'Térreo', 'Sala de Estudos 02');


INSERT INTO evento (id_local, tipo_evento, data_realizacao, horario_inicio, horario_fim, publico_alvo, tema_abordado) VALUES
(1, 'Palestra', '2026-06-24', '09:00:00', '11:00:00', 'Alunos de TI', 'Introdução à Álgebra Relacional e Bancos de Dados NoSQL'),
(2, 'Clube de Leitura', '2026-06-25', '14:00:00', '16:00:00', 'Comunidade Geral', 'Análise Crítica da Obra Dom Casmurro de Machado de Assis'),
(1, 'Palestra', '2026-06-26', '15:00:00', '17:30:00', 'Professores e Pesquisadores', 'O Impacto da Inteligência Artificial na Educação Superior'),
(1, 'Palestra', '2026-06-26', '18:00:00', '19:30:00', 'Professores e Pesquisadores', 'Metodologias Ativas de Ensino');


INSERT INTO inscricao_evento (id_evento, cpf_participante, data_inscricao) VALUES
(1, '11122233344', '2026-06-10'), 
(2, '11122233344', '2026-06-11'),
(4, '11122233344', '2026-06-11'),  
(1, '22233344455', '2026-06-12'),
(2, '88899900011', '2026-06-14'), 
(1, '44455566677', '2026-06-10'),
(3, '11122233344', '2026-06-15');



