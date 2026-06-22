# Consultas em Álgebra Relacional

## a) Quatro consultas cujos resultados contenham dados provenientes de pelo menos 3 relações.

### 1. Locais de evento, os eventos neles realizados e os usuários internos inscritos

```
JUNCAO_LOCAL_EVENTO ← local_evento ⋈id_local=id_local evento
JUNCAO_INSCRITOS ← JUNCAO_LOCAL_EVENTO ⋈id_evento=id_evento inscricao_evento ⋈cpf_participante=cpf usuario_interno
RESULTADO ← πpredio,bloco,tipo_evento,tema_abordado,nome_completo(JUNCAO_INSCRITOS)
```

### 2. Exemplares físicos disponíveis no acervo, com a obra e o autor correspondentes

```
JUNCAO_OBRA_AUTOR ← obra ⋈id_obra=id_obra obra_autor ⋈id_autor=id_autor autor
JUNCAO_ACERVO ← JUNCAO_OBRA_AUTOR ⋈id_obra=id_obra exemplar_fisico
RESULTADO ← πtitulo,nome_autor,localizacao_biblioteca,status_disponibilidade(JUNCAO_ACERVO)
```

### 3. Funcionários, seus cargos, e o histórico de uso de dispositivos de acesso

```
JUNCAO_CARGO ← usuario_interno ⋈cpf=cpf funcionario ⋈id_cargo=id_cargo cargo_funcionario
JUNCAO_USO ← JUNCAO_CARGO ⋈cpf=cpf_usuario uso_dispositivo ⋈id_dispositivo=id_dispositivo dispositivo_acesso
RESULTADO ← πnome_completo,nome_cargo,tipo_dispositivo,horario_inicio(JUNCAO_USO)
```

## b) Quatro consultas que utilizem os operadores de intersecção, união ou subtração.

### 1. Todos os participantes de eventos (internos e externos)

```
PARTICIPANTES_INTERNOS ← πcpf, nome_completo (usuario_interno ⋈cpf=cpf_participante inscricao_evento)
PARTICIPANTES_EXTERNOS ← πcpf, nome_completo (participante_externo ⋈cpf=cpf_participante inscricao_evento)
RESULTADO ←
∪
πcpf, nome_completo,
′Interno′→tipo_participante(PARTICIPANTES_INTERNOS)
πcpf, nome_completo,
′Externo′→tipo_participante(PARTICIPANTES_EXTERNOS)
```

### 2. Usuários internos que estão inscritos em pelo menos um evento

```
RESULTADO ← πcpf (usuario_interno) ∩ ρcpf←cpf_participante(πcpf_participante(inscricao_evento))
```

### 3. Usuários que nunca se inscreveram em nenhum evento

```
USUARIOS_INSCRITOS ← πcpf, nome_completo (usuario_interno ⋈cpf=cpf_participante inscricao_evento)
RESULTADO ← πcpf, nome_completo(usuario_interno) − USUARIOS_INSCRITOS
```

### 4. CPFs com vínculo ativo (empréstimo ou evento futuro)

```
EMPRESTIMOS_ABERTOS ← σdata_efetiva_devolucao=NULL(emprestimo)
EVENTOS_FUTUROS ← σdata_realizacao≥DATA_ATUAL(inscricao_evento ⋈ evento)
RESULTADO ←
∪
πcpf_usuario→cpf,
′Emprestimo em aberto′→vinculo(EMPRESTIMOS_ABERTOS)
πcpf_participante→cpf,
′Inscricao em evento futuro′→vinculo(EVENTOS_FUTUROS)
```

## c) Quatro consultas para cada tipo de junção (interna, externa total, externa à esquerda, externa à direita).

### -------- JUNÇÃO INTERNA --------

#### 1. Histórico de Empréstimos Ativos de Alunos

```
EMPRESTIMOS_ATIVOS ← σdata_efetiva_devolucao=NULL(emprestimo)
JUNCAO_TOTAL ← usuario_interno ⋈cpf=cpf aluno ⋈cpf=cpf_usuario EMPRESTIMOS_ATIVOS
⋈id_exemplar=id_exemplar exemplar_fisico ⋈id_obra=id_obra obra
RESULTADO ← πnome_completo,numero_matricula,titulo,data_retirada,data_prevista_devolucao(JUNCAO_TOTAL)
```

#### 2. Nomes de Autores das Obras em Processo de Manutenção Física

```
EXEMPLARES_MANUTENCAO ← σstatus_disponibilidade='Em Manutenção'(exemplar_fisico)
CADEIA_AUTOR ← autor ⋈id_autor=id_autor obra_autor ⋈id_obra=id_obra obra ⋈id_obra=id_obra
EXEMPLARES_MANUTENCAO
RESULTADO ← πnome_autor,titulo,id_exemplar,localizacao_biblioteca(CADEIA_AUTOR)
```

#### 3. Professores Inscritos em Palestras da Instituição

```
PALESTRAS ← σtipo_evento='Palestra'(evento)
INSCRICOES_PROF ← usuario_interno ⋈cpf=cpf professor ⋈cpf=cpf_participante inscricao_evento ⋈id_evento=id_evento
PALESTRAS
RESULTADO ← πnome_completo,siape,tema_abordado,data_realizacao(INSCRICOES_PROF)
```

#### 4. Escala de Funcionários com seus Respectivos Cargos e Turnos

```
JUNCAO_ESCALA ← usuario_interno ⋈cpf=cpf funcionario ⋈id_cargo=id_cargo cargo_funcionario
RESULTADO ← πnome_completo,nome_cargo,turno(JUNCAO_ESCALA)
```

### -------- JUNÇÃO EXTERNA A ESQUERDA --------

#### 1. Todos os utilizadores cadastrados e os seus empréstimos

```
JUNCAO_USUARIOS ← usuario_interno ⟕cpf=cpf_usuario emprestimo
RESULTADO ← πnome_completo,email_institucional,id_exemplar,data_retirada(JUNCAO_USUARIOS)
```

#### 2. Catálogo completo de obras e a sua disponibilidade virtual (E-books)

```
CATALOGO_GERAL ← obra ⟕id_obra=id_obra ebook
RESULTADO ← πtitulo,ano_publicacao,link_acesso(CATALOGO_GERAL)
```

#### 3. Mapeamento de todos os espaços da universidade e os eventos lá agendados

```
MAPA_ESPACOS ← local_evento ⟕id_local=id_local evento
RESULTADO ← πpredio,bloco,capacidade_maxima,tema_abordado,data_realizacao(MAPA_ESPACOS)
```

#### 4. Todos os dispositivos e o respectivo histórico de utilização

```
CONTROLE_DISPOSITIVOS ← dispositivo_acesso ⟕id_dispositivo=id_dispositivo uso_dispositivo
RESULTADO ← πid_dispositivo,tipo_dispositivo,horario_inicio,horario_fim,cpf_usuario(CONTROLE_DISPOSITIVOS)
```

### -------- JUNÇÃO EXTERNA A DIREITA --------

#### 1. Todos os exemplares físicos e o seu histórico de saídas

```
HISTORICO_EXEMPLARES ← emprestimo ⟖id_exemplar=id_exemplar exemplar_fisico
RESULTADO ← πdata_retirada,data_prevista_devolucao,id_exemplar,localizacao_biblioteca,status_disponibilidade(HISTORICO_EXEMPLARES)
```

#### 2. Todos os Autores cadastrados e as obras associadas a eles

```
OBRAS_AUTORES ← obra ⋈id_obra=id_obra obra_autor
TODOS_AUTORES ← OBRAS_AUTORES ⟖id_autor=id_autor autor
RESULTADO ← πtitulo,ano_publicacao,nome_autor(TODOS_AUTORES)
```

#### 3. Todos os Convidados Externos e as suas inscrições confirmadas

```
INSCRICOES_CONVIDADOS ← inscricao_evento ⟖cpf_participante=cpf participante_externo
RESULTADO ← πid_evento,data_inscricao,nome_completo,instituicao_origem(INSCRICOES_CONVIDADOS)
```

#### 4. Quadro de Eventos Cadastrados e o Volume de Inscrições

```
EVENTOS_INSCRICOES ← inscricao_evento ⟖id_evento=id_evento evento
RESULTADO ← πtema_abordado,tipo_evento,data_realizacao,cpf_participante,data_inscricao(EVENTOS_INSCRICOES)
```

### -------- JUNÇÃO EXTERNA TOTAL --------

#### 1. Obra e seus exemplares físicos, inclusive obras sem exemplares e exemplares órfãos

```
OBRA_EXEMPLAR ← obra ⟗id_obra=id_obra exemplar_fisico
RESULTADO ← πtitulo,editora,id_exemplar,localizacao_biblioteca,status_disponibilidade(OBRA_EXEMPLAR)
```

#### 2. Eventos e suas inscrições, inclusive eventos sem inscritos

```
EVENTO_INSCRICAO ← evento ⟗id_evento=id_evento inscricao_evento
RESULTADO ← πid_evento,tipo_evento,tema_abordado,data_realizacao,cpf_participante,data_inscricao(EVENTO_INSCRICAO)
```

#### 3. Usuários internos e inscrições em evento, identificando quem nunca se inscreveu

```
USUARIO_INSCRICAO ← usuario_interno ⟗cpf=cpf_participante inscricao_evento
RESULTADO ← πnome_completo,id_evento,data_inscricao,situacao(USUARIO_INSCRICAO)
```

#### 4. Locais de evento e os eventos realizados, inclusive locais sem evento agendado

```
LOCAL_EVENTO ← local_evento ⟗id_local=id_local evento
RESULTADO ← πpredio,andar,bloco,capacidade_maxima,tipo_evento,data_realizacao,publico_alvo(LOCAL_EVENTO)
```

## d) Duas consultas usando o operador de divisão.

### 1. Usuários inscritos em TODAS as Palestras

```
PALESTRAS ← πid_evento(σtipo_evento='Palestra'(evento))
INSCRICOES_PALESTRA ← πcpf_participante,id_evento(inscricao_evento⋉PALESTRAS)
USUARIOS_TODAS_PALESTRAS ← INSCRICOES_PALESTRA ÷ PALESTRAS
```

### 2. Usuários que pegaram empréstimo de TODOS os exemplares de uma obra

```
EXEMPLARES_OBRA ← πid_exemplar(σid_obra=1(exemplar_fisico))
EMPRESTIMOS_OBRA ← πcpf_usuario,id_exemplar(emprestimo⋉EXEMPLARES_OBRA)
USUARIOS_TODOS_EXEMPLARES ← EMPRESTIMOS_OBRA ÷ EXEMPLARES_OBRA
```

## e) Sete consultas utilizando funções agregadas.

### 1. Total de empréstimos e multa acumulada por usuário

```
EMPRESTIMOS_USUARIO ← usuario_interno ⋈cpf=cpf_usuario emprestimo
RESULTADO ← Fnome_completo(COUNT(id_emprestimo) → total_emprestimos,
SUM(multa_atraso) → multa_total,
AVG(multa_atraso) → multa_media)(EMPRESTIMOS_USUARIO)
```

### 2. Número de obras por autor e idioma

```
AUTOR_OBRA ← autor ⋈id_autor=id_autor obra_autor
AUTOR_OBRA_IDIOMA ← AUTOR_OBRA ⋈id_obra=id_obra obra
RESULTADO ← Fnome_autor, idioma(COUNT(id_obra) → total_obras)(AUTOR_OBRA_IDIOMA)
```

### 3. Obras com mais de um autor cadastrado na tabela obra_autor

```
OBRAS_AUTORES ← obra ⋈id_obra=id_obra obra_autor
AGRUPAMENTO ← Fid_obra, titulo, editora, ano_publicacao(COUNT(id_autor) → total_autores)(OBRAS_AUTORES)
RESULTADO ← σtotal_autores>1(AGRUPAMENTO)
```

### 4. Total de inscrições por evento e tipo, com nome do local

```
EVENTO_LOCAL ← evento ⋈id_local=id_local local_evento
EVENTO_INSCRICAO ← EVENTO_LOCAL ⋈id_evento=id_evento inscricao_evento
RESULTADO ← Fid_evento, tipo_evento, tema_abordado, predio(COUNT(cpf_participante) → total_inscritos)(EVENTO_INSCRICAO)
```

### 5. Quantidade de exemplares físicos por obra e por status de disponibilidade

```
OBRA_EXEMPLAR ← obra ⋈id_obra=id_obra exemplar_fisico
RESULTADO ← Ftitulo, status_disponibilidade(COUNT(id_exemplar) → qtd_exemplares)(OBRA_EXEMPLAR)
```

### 6. Capacidade total e média dos locais de evento agrupados por prédio

```
RESULTADO ← Fpredio(COUNT(id_local) → total_salas,
SUM(capacidade_maxima) → capacidade_total,
AVG(capacidade_maxima) → capacidade_media,
MAX(capacidade_maxima) → maior_capacidade,
MIN(capacidade_maxima) → menor_capacidade)(local_evento)
```

### 7. Quantidade de eventos por tipo e público-alvo

```
AGRUPAMENTO ← Ftipo_evento, publico_alvo(COUNT(id_evento) → total_eventos,
MIN(data_realizacao) → primeiro_evento,
MAX(data_realizacao) → ultimo_evento)(evento)
RESULTADO ← σtotal_eventos>1(AGRUPAMENTO)
```