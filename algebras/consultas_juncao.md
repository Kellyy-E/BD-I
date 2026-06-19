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
