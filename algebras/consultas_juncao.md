### -------- JUNÇÃO INTERNA --------

### 1. Histórico de Empréstimos Ativos de Alunos

$$
\text{EMPRESTIMOS\_ATIVOS} \leftarrow \sigma_{data\_efetiva\_devolucao = \text{NULL}}(\text{emprestimo})
$$

$$
\text{JUNCAO\_TOTAL} \leftarrow \text{usuario\_interno} \bowtie_{cpf=cpf} \text{aluno} \bowtie_{cpf=cpf\_usuario} \text{EMPRESTIMOS\_ATIVOS} \bowtie_{id\_exemplar=id\_exemplar} \text{exemplar\_fisico} \bowtie_{id\_obra=id\_obra} \text{obra}
$$

$$
\text{RESULTADO} \leftarrow \pi_{nome\_completo, numero\_matricula, titulo, data\_retirada, data\_prevista\_devolucao}(\text{JUNCAO\_TOTAL})
$$

### 2. Nomes de Autores das Obras em Processo de Manutenção Física

$$
\text{EXEMPLARES\_MANUTENCAO} \leftarrow \sigma_{status\_disponibilidade = \text{'Em Manutenção'}}(\text{exemplar\_fisico})
$$

$$
\text{CADEIA\_AUTOR} \leftarrow \text{autor} \bowtie_{id\_author=id\_author} \text{obra\_autor} \bowtie_{id\_obra=id\_obra} \text{obra} \bowtie_{id\_obra=id\_obra} \text{EXEMPLARES\_MANUTENCAO}
$$

$$
\text{RESULTADO} \leftarrow \pi_{nome\_autor, titulo, id\_exemplar, localizacao\_biblioteca}(\text{CADEIA\_AUTOR})
$$

### 3. Professores Inscritos em Palestras da Instituição

$$
\text{PALESTRAS} \leftarrow \sigma_{tipo\_evento = \text{'Palestra'}}(\text{evento})
$$

$$
\text{INSCRICOES\_PROF} \leftarrow \text{usuario\_interno} \bowtie_{cpf=cpf} \text{professor} \bowtie_{cpf=cpf\_participante} \text{inscricao\_evento} \bowtie_{id\_evento=id\_evento} \text{PALESTRAS}
$$

$$
\text{RESULTADO} \leftarrow \pi_{nome\_completo, siape, tema\_abordado, data\_realizacao}(\text{INSCRICOES\_PROF})
$$

### 4. Escala de Funcionários com seus Respectivos Cargos e Turnos

$$
\text{JUNCAO\_ESCALA} \leftarrow \text{usuario\_interno} \bowtie_{cpf=cpf} \text{funcionario} \bowtie_{id\_cargo=id\_cargo} \text{cargo\_funcionario}
$$

$$
\text{RESULTADO} \leftarrow \pi_{nome\_completo, nome\_cargo, turno\_work}(\text{JUNCAO\_ESCALA})
$$

### -------- JUNÇÃO EXTERNA A ESQUERDA --------

### 1. Todos os utilizadores cadastrados e os seus empréstimos

$$\text{JUNCAO\_USUARIOS} \leftarrow \text{usuario\_interno} \subset\bowtie_{cpf = cpf\_usuario} \text{emprestimo}$$

$$\text{RESULTADO} \leftarrow \pi_{nome\_completo, email\_institucional, id\_exemplar, data\_retirada}(\text{JUNCAO\_USUARIOS})$$


### 2. Catálogo completo de obras e a sua disponibilidade virtual (E-books)

$$\text{CATALOGO\_GERAL} \leftarrow \text{obra} \subset\bowtie_{id\_obra = id\_obra} \text{ebook}$$

$$\text{RESULTADO} \leftarrow \pi_{titulo, ano\_publicacao, link\_acesso}(\text{CATALOGO\_GERAL})$$


### 3. Mapeamento de todos os espaços da universidade e os eventos lá agendados

$$\text{MAPA\_ESPACOS} \leftarrow \text{local\_evento} \subset\bowtie_{id\_local = id\_local} \text{evento}$$

$$\text{RESULTADO} \leftarrow \pi_{predio, bloco, capacidade\_maxima, tema\_abordado, data\_realizacao}(\text{MAPA\_ESPACOS})$$


### 4. Todos os dispositivos e o respectivo histórico de utilização

$$\text{CONTROLE\_DISPOSITIVOS} \leftarrow \text{dispositivo\_acesso} \subset\bowtie_{id\_dispositivo = id\_dispositivo} \text{uso\_dispositivo}$$

$$\text{RESULTADO} \leftarrow \pi_{id\_dispositivo, tipo\_dispositivo, horario\_inicio, horario\_fim, cpf\_usuario}(\text{CONTROLE\_DISPOSITIVOS})$$


### -------- JUNÇÃO EXTERNA A DIREITA --------
### 1. Todos os exemplares físicos e o seu histórico de saídas

$$\text{HISTORICO\_EXEMPLARES} \leftarrow \text{emprestimo} \bowtie\supset_{id\_exemplar = id\_exemplar} \text{exemplar\_fisico}$$

$$\text{RESULTADO} \leftarrow \pi_{data\_retirada, data\_prevista\_devolucao, id\_exemplar, localizacao\_biblioteca, status\_disponibilidade}(\text{HISTORICO\_EXEMPLARES})$$

### 2. Todos os Autores cadastrados e as obras associadas a eles

$$\text{OBRAS\_AUTORES} \leftarrow \text{obra} \bowtie_{id\_obra = id\_obra} \text{obra\_autor}$$

$$\text{TODOS\_AUTORES} \leftarrow \text{OBRAS\_AUTORES} \bowtie\supset_{id\_author = id\_author} \text{autor}$$

$$\text{RESULTADO} \leftarrow \pi_{titulo, ano\_publicacao, nome\_autor}(\text{TODOS\_AUTORES})$$


### 3. Todos os Convidados Externos e as suas inscrições confirmadas

$$\text{INSCRICOES\_CONVIDADOS} \leftarrow \text{inscricao\_evento} \bowtie\supset_{cpf\_participante = cpf} \text{participante\_external}$$

$$\text{RESULTADO} \leftarrow \pi_{id\_evento, data\_inscricao, nome\_completo, instituicao\_origem}(\text{INSCRICOES\_CONVIDADOS})$$


### 4. Quadro de Eventos Cadastrados e o Volume de Inscrições
$$\text{EVENTOS\_INSCRICOES} \leftarrow \text{inscricao\_evento} \bowtie\supset_{id\_evento = id\_evento} \text{evento}$$

$$\text{RESULTADO} \leftarrow \pi_{tema\_abordado, tipo\_evento, data\_realizacao, cpf\_participante, data\_inscricao}(\text{EVENTOS\_INSCRICOES})$$


### -------- JUNÇÃO EXTERNA TOTAL --------
### 1 - Obra e seus exemplares fisicos, inclusive obras sem exemplares e exemplares órfaos

$$
\text{OBRA\_EXEMPLAR} \leftarrow \text{obra} \;\text{FULL OUTER JOIN}_{id\_obra = id\_obra}\; \text{exemplar\_fisico}
$$

$$
\text{RESULTADO} \leftarrow \pi_{titulo, editora, id\_exemplar, localizacao\_biblioteca, status\_disponibilidade}(\text{OBRA\_EXEMPLAR})
$$

### 2 - Eventos e suas inscrições inclusive eventos em inscritos

$$
\text{EVENTO\_INSCRICAO} \leftarrow \text{evento} \;\text{FULL OUTER JOIN}_{id\_evento = id\_evento}\; \text{inscricao\_evento}
$$

$$
\text{RESULTADO} \leftarrow \pi_{id\_evento, tipo\_evento, tema\_abordado, data\_realizacao, cpf\_participante, data\_inscricao}(\text{EVENTO\_INSCRICAO})
$$

### 3 - usuários internos e inscrições em evento identificando quem nunca se inscreveu

$$
\text{USUARIO\_INSCRICAO} \leftarrow \text{usuario\_interno} \;\text{FULL OUTER JOIN}_{cpf = cpf\_participante}\; \text{inscricao\_evento}
$$

$$
\text{RESULTADO} \leftarrow \pi_{nome\_completo, id\_evento, data\_inscricao, situacao}(\text{USUARIO\_INSCRICAO})
$$


### 4 - locais de evento e os eventos realizados inclusive locais sem evento agendado

$$
\text{LOCAL\_EVENTO} \leftarrow \text{local\_evento} \;\text{FULL OUTER JOIN}_{id\_local = id\_local}\; \text{evento}
$$

$$
\text{RESULTADO} \leftarrow \pi_{predio, andar, bloco, capacidade\_maxima, tipo\_evento, data\_realizacao, publico\_alvo}(\text{LOCAL\_EVENTO})
$$