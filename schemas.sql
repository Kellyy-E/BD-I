
CREATE DATABASE trabalhofinal
-- ----------------------------------------------------------------------------
-- DROP TABLES (Garantir reexecução limpa do script)

DROP TABLE IF EXISTS inscricao_evento CASCADE;
DROP TABLE IF EXISTS participante_external CASCADE;
DROP TABLE IF EXISTS evento CASCADE;
DROP TABLE IF EXISTS local_evento CASCADE;
DROP TABLE IF EXISTS emprestimo CASCADE;
DROP TABLE IF EXISTS dispositivo_acesso CASCADE;
DROP TABLE IF EXISTS obra_autor CASCADE;
DROP TABLE IF EXISTS autor CASCADE;
DROP TABLE IF EXISTS exemplar_fisico CASCADE;
DROP TABLE IF EXISTS ebook CASCADE;
DROP TABLE IF EXISTS obra CASCADE;
DROP TABLE IF EXISTS funcionario CASCADE;
DROP TABLE IF EXISTS professor CASCADE;
DROP TABLE IF EXISTS aluno CASCADE;
DROP TABLE IF EXISTS usuario_interno CASCADE;
DROP TABLE IF EXISTS cargo_funcionario CASCADE;
DROP TABLE IF EXISTS uso_dispositivo CASCADE;

-- -----------------------------------------------------------------------------
CRIAÇÃO DAS TABELAS E RESTRIÇÕES DE INTEGRIDADE

-- MÓDULO DE USUÁRIOS, CARGOS E INSCRIÇÕES
CREATE TABLE cargo_funcionario (
    id_cargo SERIAL,
    nome_cargo VARCHAR(50) NOT NULL,
    CONSTRAINT pk_cargo_funcionario PRIMARY KEY (id_cargo),
    CONSTRAINT chk_nome_cargo CHECK (nome_cargo IN ('Atendimento', 'Catalogação', 'Digitalização'))
);

CREATE TABLE usuario_interno (
    cpf CHAR(11),
    nome_completo VARCHAR(150) NOT NULL,
    email_institucional VARCHAR(100) NOT NULL,
    telefone VARCHAR(15),
    endereco VARCHAR(200),
    CONSTRAINT pk_usuario_interno PRIMARY KEY (cpf),
    CONSTRAINT un_email_institucional UNIQUE (email_institucional)
);

CREATE TABLE aluno (
    cpf CHAR(11),
    numero_matricula VARCHAR(20) NOT NULL,
    CONSTRAINT pk_aluno PRIMARY KEY (cpf),
    CONSTRAINT un_matricula UNIQUE (numero_matricula),
    CONSTRAINT fk_aluno_usuario FOREIGN KEY (cpf) 
        REFERENCES usuario_interno(cpf) ON DELETE CASCADE
);

CREATE TABLE professor (
    cpf CHAR(11),
    siape VARCHAR(20) NOT NULL,
    CONSTRAINT pk_professor PRIMARY KEY (cpf),
    CONSTRAINT un_siape UNIQUE (siape),
    CONSTRAINT fk_professor_usuario FOREIGN KEY (cpf) 
        REFERENCES usuario_interno(cpf) ON DELETE CASCADE
);

CREATE TABLE funcionario (
    cpf CHAR(11),
    turno VARCHAR(20) NOT NULL,
    id_cargo INT NOT NULL,
    CONSTRAINT pk_funcionario PRIMARY KEY (cpf),
    CONSTRAINT fk_funcionario_usuario FOREIGN KEY (cpf) 
        REFERENCES usuario_interno(cpf) ON DELETE CASCADE,
    CONSTRAINT fk_funcionario_cargo FOREIGN KEY (id_cargo) 
        REFERENCES cargo_funcionario(id_cargo) ON DELETE RESTRICT,
    CONSTRAINT chk_turno CHECK (turno IN ('Manhã', 'Tarde', 'Noite'))
);

CREATE TABLE participante_external (
    cpf CHAR(11),
    chave_convite_unica VARCHAR(50) NOT NULL,
    nome_completo VARCHAR(150) NOT NULL,
    email_contato VARCHAR(100) NOT NULL,
    instituicao_origem VARCHAR(100),
    CONSTRAINT pk_participante_external PRIMARY KEY (cpf),
    CONSTRAINT un_chave_convite UNIQUE (chave_convite_unica)
);

-- MÓDULO DO CATÁLOGO DE OBRAS E AUTORES
CREATE TABLE obra (
    id_obra SERIAL,
    titulo VARCHAR(200) NOT NULL,
    editora VARCHAR(100),
    ano_publicacao INT,
    idioma VARCHAR(50),
    num_paginas_ou_duracao INT,
    CONSTRAINT pk_obra PRIMARY KEY (id_obra)
);

CREATE TABLE ebook (
    id_obra INT,
    link_acesso VARCHAR(255) NOT NULL,
    CONSTRAINT pk_ebook PRIMARY KEY (id_obra),
    CONSTRAINT fk_ebook_obra FOREIGN KEY (id_obra) 
        REFERENCES obra(id_obra) ON DELETE CASCADE
);

CREATE TABLE exemplar_fisico (
    id_exemplar SERIAL,
    id_obra INT NOT NULL,
    localizacao_biblioteca VARCHAR(100) NOT NULL,
    status_disponibilidade VARCHAR(20) NOT NULL,
    CONSTRAINT pk_exemplar_fisico PRIMARY KEY (id_exemplar),
    CONSTRAINT fk_exemplar_obra FOREIGN KEY (id_obra) 
        REFERENCES obra(id_obra) ON DELETE CASCADE,
    CONSTRAINT chk_status_exemplar CHECK (status_disponibilidade IN ('Disponível', 'Emprestado', 'Em Manutenção'))
);

CREATE TABLE autor (
    id_author SERIAL,
    nome_autor VARCHAR(100) NOT NULL,
    CONSTRAINT pk_autor PRIMARY KEY (id_author)
);

CREATE TABLE obra_autor (
    id_obra INT,
    id_author INT,
    CONSTRAINT pk_obra_autor PRIMARY KEY (id_obra, id_author),
    CONSTRAINT fk_obra_autor_obra FOREIGN KEY (id_obra) 
        REFERENCES obra(id_obra) ON DELETE CASCADE,
    CONSTRAINT fk_obra_autor_autor FOREIGN KEY (id_author) 
        REFERENCES autor(id_author) ON DELETE CASCADE
);

-- MÓDULO DE CIRCULAÇÃO (EMPRÉSTIMOS) E EQUIPAMENTOS
CREATE TABLE dispositivo (
    id_dispositivo SERIAL,
    tipo_dispositivo VARCHAR(20) NOT NULL,
    sistema_operacional VARCHAR(50),
    status_disponibilidade VARCHAR(20) NOT NULL,
    CONSTRAINT pk_dispositivo_acesso PRIMARY KEY (id_dispositivo),
    CONSTRAINT chk_tipo_disp CHECK (tipo_dispositivo IN ('Computador', 'Notebook')),
    CONSTRAINT chk_status_disp CHECK (status_disponibilidade IN ('Disponível', 'Em Uso', 'Em Manutenção'))
);

CREATE TABLE uso_dispositivo (
    id_acesso SERIAL,
    id_dispositivo INT NOT NULL,
    cpf_usuario CHAR(11) NOT NULL,
    horario_inicio TIMESTAMP NOT NULL,
    horario_fim TIMESTAMP,
    
    CONSTRAINT pk_uso_dispositivo PRIMARY KEY (id_acesso),
    
    CONSTRAINT fk_uso_dispositivo_disp FOREIGN KEY (id_dispositivo)
        REFERENCES dispositivo_acesso(id_dispositivo) ON DELETE RESTRICT,
        
    CONSTRAINT fk_uso_dispositivo_usuario FOREIGN KEY (cpf_usuario)
        REFERENCES usuario_interno(cpf) ON DELETE RESTRICT,
        
    CONSTRAINT chk_horarios_uso CHECK (horario_fim >= horario_inicio)
);

CREATE TABLE emprestimo (
    id_emprestimo SERIAL,
    cpf_usuario CHAR(11) NOT NULL,
    id_exemplar INT NOT NULL,
    data_retirada DATE NOT NULL,
    data_prevista_devolucao DATE NOT NULL,
    data_efetiva_devolucao DATE,
    multa_atraso NUMERIC(10, 2) DEFAULT 0.00,
    CONSTRAINT pk_emprestimo PRIMARY KEY (id_emprestimo),
    CONSTRAINT fk_emprestimo_usuario FOREIGN KEY (cpf_usuario) 
        REFERENCES usuario_interno(cpf) ON DELETE RESTRICT,
    CONSTRAINT fk_emprestimo_exemplar FOREIGN KEY (id_exemplar) 
        REFERENCES exemplar_fisico(id_exemplar) ON DELETE RESTRICT,
    CONSTRAINT chk_datas CHECK (data_prevista_devolucao >= data_retirada)
);

-- MÓDULO DE INFRAESTRUTURA E EVENTOS
CREATE TABLE local_evento (
    id_local SERIAL,
    capacidade_maxima INT NOT NULL,
    predio VARCHAR(50) NOT NULL,
    andar VARCHAR(20),
    bloco VARCHAR(20),
    CONSTRAINT pk_local_evento PRIMARY KEY (id_local)
);

CREATE TABLE evento (
    id_evento SERIAL,
    id_local INT NOT NULL,
    tipo_evento VARCHAR(30) NOT NULL,
    data_realizacao DATE NOT NULL,
    horario_inicio TIME NOT NULL,       
    horario_fim TIME NOT NULL,          
    publico_alvo VARCHAR(50),
    tema_abordado VARCHAR(150),
    
    CONSTRAINT pk_evento PRIMARY KEY (id_evento),
    
    CONSTRAINT fk_evento_local FOREIGN KEY (id_local)
        REFERENCES local_evento(id_local) ON DELETE RESTRICT,
        
    CONSTRAINT chk_tipo_evento CHECK (tipo_evento IN ('Club de Leitura', 'Palestra')),
    
    CONSTRAINT chk_horarios_evento CHECK (horario_fim > horario_inicio)
);

CREATE TABLE inscricao_evento (
    id_evento INT,
    cpf_participante CHAR(11),
    data_inscricao DATE NOT NULL,
    CONSTRAINT pk_inscricao_evento PRIMARY KEY (id_evento, cpf_participante),
    CONSTRAINT fk_inscricao_evento_ev FOREIGN KEY (id_evento) 
        REFERENCES evento(id_evento) ON DELETE CASCADE
);

