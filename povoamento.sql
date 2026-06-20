-- 1. CARGOS DOS FUNCIONÁRIOS
INSERT INTO cargo_funcionario (nome_cargo) VALUES 
('Atendimento'),
('Catalogação'),
('Digitalização');

-- 2. USUÁRIOS INTERNOS (Base para Alunos, Professores e Funcionários)
INSERT INTO usuario_interno (cpf, nome_completo, email_institucional, telefone, endereco) VALUES
('11122233344', 'Carlos Augusto Silva', 'carlos.aluno@ufpi.edu.br', '89999112233', 'Rua 24 de Janeiro, 120 - Centro'),
('22233344455', 'Mariana Costa Sousa', 'mariana.aluna@ufpi.edu.br', '89999223344', 'Av. Nossa Senhora de Fátima, 450'),
('33344455566', 'Bruna Oliveira Lima', 'bruna.aluna@ufpi.edu.br', '89999334455', 'Rua Monsenhor Hipólito, 890'),
('44455566677', 'Profa. Ana Maria Sousa', 'anamaria.prof@ufpi.edu.br', '89999445566', 'Bairro Canto da Várzea'),
('55566677788', 'Prof. Raimundo Nonato', 'rnonato.prof@ufpi.edu.br', '89999556677', 'Rua Teresina, 32'),
('66677788899', 'Francisco José Costa', 'francisco.func@ufpi.edu.br', '89999667788', 'Bairro Junco'),
('77788899900', 'Antônia Alves Rocha', 'antonia.func@ufpi.edu.br', '89999778899', 'Bairro Aerolândia');


-- 3. SUBCLASSES DE USUÁRIOS (Herança)
INSERT INTO aluno (cpf, numero_matricula) VALUES 
('11122233344', '2023901234'),
('22233344455', '2024905678'),
('33344455566', '2025901122');

INSERT INTO professor (cpf, siape) VALUES 
('44455566677', '1004321'),
('55566677788', '2008765');

INSERT INTO funcionario (cpf, turno_work, id_cargo) VALUES 
('66677788899', 'Manhã', 1), -- Atendimento
('77788899900', 'Tarde', 2); -- Catalogação

-- 4. PARTICIPANTES EXTERNOS (Para os Eventos)
INSERT INTO participante_external (cpf, chave_convite_unica, nome_completo, email_contato, instituicao_origem) VALUES
('88899900011', 'CONV-24-XTZ', 'Marcos Viana Oliveira', 'marcos.viana@gmail.com', 'IFPI Campus Picos'),
('99900011122', 'CONV-24-ABC', 'Juliana de Castro Reis', 'ju.castro@hotmail.com', 'UESPI');

-- 5. AUTORES
INSERT INTO autor (nome_autor) VALUES
('Ramez Elmasri'),
('Shamkant B. Navathe'),
('Robert C. Martin'),
('Abraham Silberschatz');

-- 6. OBRAS (Catálogo Geral)
INSERT INTO obra (titulo, editora, ano_publicacao, idioma, num_paginas_ou_duracao) VALUES
('Sistemas de Banco de Dados', 'Pearson', 2011, 'Português', 700),
('Clean Code', 'Alta Books', 2009, 'Inglês', 464),
('Sistemas Operacionais Modernos', 'Pearson', 2015, 'Português', 600),
('Algoritmos e Estruturas de Dados', 'LTC', 2018, 'Português', 400);

-- 7. MAPEAMENTO MUITOS-PARA-MUITOS (Obras e Autores)
INSERT INTO obra_autor (id_obra, id_author) VALUES
(1, 1),
(1, 2), 
(2, 3), 
(3, 4); 

-- 8. EBOOKS (Relacionamento 1:1 com Obra)
INSERT INTO ebook (id_obra, link_acesso) VALUES
(2, 'https://biblioteca.ufpi.br/ebooks/cleancode.pdf');

-- 9. EXEMPLARES FÍSICOS (Inventário das Obras Físicas)
INSERT INTO exemplar_fisico (id_obra, localizacao_biblioteca, status_disponibilidade) VALUES
(1, 'Estante 04, Prateleira B', 'Disponível'),
(1, 'Estante 04, Prateleira B', 'Emprestado'), 
(1, 'Estante 04, Prateleira C', 'Emprestado'),
(3, 'Estante 02, Prateleira A', 'Disponível'),
(4, 'Estante 01, Prateleira D', 'Disponível');

-- 10. DISPOSITIVOS DE ACESSO
INSERT INTO dispositivo_acesso (tipo_dispositivo, sistema_operacional, status_disponibilidade) VALUES
('Computador', 'Ubuntu Linux 24.04', 'Disponível'),
('Computador', 'Ubuntu Linux 24.04', 'Em Manutenção'),
('Notebook', 'Windows 11', 'Em Uso');

INSERT INTO uso_dispositivo (id_dispositivo, cpf_usuario, horario_inicio, horario_fim) VALUES
(1, '11122233344', '2026-06-18 08:00:00', '2026-06-18 10:00:00'), 
(1, '22233344455', '2026-06-15 08:00:00', '2026-06-15 10:00:00'), 
(2, '22233344455', '2026-06-18 14:00:00', NULL),
(3, '66677788899','2026-06-15 08:00:00', '2026-06-15 10:00:00');         

-- 11. EMPRÉSTIMOS
INSERT INTO emprestimo (cpf_usuario, id_exemplar, data_retirada, data_prevista_devolucao, data_efetiva_devolucao, multa_atraso) VALUES
('11122233344', 1, '2026-05-10', '2026-05-24', '2026-05-20', 0.00), 
('11122233344', 2, '2026-06-01', '2026-06-15', NULL, 0.00),        
('22233344455', 4, '2026-05-01', '2026-05-15', '2026-05-20', 15.50),
('22233344455', 1, '2026-02-10', '2026-02-24', '2026-02-20', 0.00), 
('22233344455', 2, '2026-03-01', '2026-03-15', '2026-03-12', 0.00),
('22233344455', 3, '2026-04-05', '2026-04-19', '2026-04-15', 0.00); 


-- 12. INFRAESTRUTURA (Locais dos Eventos)
INSERT INTO local_evento (capacidade_maxima, predio, andar, bloco) VALUES
(50, 'Bloco de Sistemas', '1º Andar', 'Auditório B'),
(30, 'Biblioteca Central', 'Térreo', 'Sala de Estudos 01');

-- 13. EVENTOS
INSERT INTO evento (id_local, tipo_evento, data_realizacao, horario_inicio, horario_fim, publico_alvo, tema_abordado) VALUES
(1, 'Palestra', '2026-06-24', '09:00:00', '11:00:00', 'Alunos de TI', 'Introdução à Álgebra Relacional e Bancos de Dados NoSQL'),
(2, 'Club de Leitura', '2026-06-25', '14:00:00', '16:00:00', 'Comunidade Geral', 'Análise Crítica da Obra Dom Casmurro de Machado de Assis'),
(1, 'Palestra', '2026-06-26', '15:00:00', '17:30:00', 'Professores e Pesquisadores', 'O Impacto da Inteligência Artificial na Educação Superior');

-- 14. INSCRIÇÕES NOS EVENTOS 
INSERT INTO inscricao_evento (id_evento, cpf_participante, data_inscricao) VALUES
(1, '11122233344', '2026-06-10'), 
(2, '11122233344', '2026-06-11'), 
(1, '22233344455', '2026-06-12'),
(2, '88899900011', '2026-06-14'), 
(1, '44455566677', '2026-06-10'),
(3, '11122233344', '2026-06-15');



