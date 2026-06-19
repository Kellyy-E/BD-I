### -------- CONSULTAS COM DADOS DE PELO MENOS 3 RELAÇÕES --------

### 1. Locais de evento, os eventos neles realizados e os usuários internos inscritos

$$
\text{JUNCAO\_LOCAL\_EVENTO} \leftarrow \text{local\_evento} \bowtie_{id\_local=id\_local} \text{evento}
$$

$$
\text{JUNCAO\_INSCRITOS} \leftarrow \text{JUNCAO\_LOCAL\_EVENTO} \bowtie_{id\_evento=id\_evento} \text{inscricao\_evento} \bowtie_{cpf\_participante=cpf} \text{usuario\_interno}
$$

$$
\text{RESULTADO} \leftarrow \pi_{predio, bloco, tipo\_evento, tema\_abordado, nome\_completo}(\text{JUNCAO\_INSCRITOS})
$$

### 2. Exemplares físicos disponíveis no acervo, com a obra e o autor correspondentes

$$
\text{JUNCAO\_OBRA\_AUTOR} \leftarrow \text{obra} \bowtie_{id\_obra=id\_obra} \text{obra\_autor} \bowtie_{id\_author=id\_author} \text{autor}
$$

$$
\text{JUNCAO\_ACERVO} \leftarrow \text{JUNCAO\_OBRA\_AUTOR} \bowtie_{id\_obra=id\_obra} \text{exemplar\_fisico}
$$

$$
\text{RESULTADO} \leftarrow \pi_{titulo, nome\_autor, localizacao\_biblioteca, status\_disponibilidade}(\text{JUNCAO\_ACERVO})
$$

### 3. Funcionários, seus cargos, e o histórico de uso de dispositivos de acesso

$$
\text{JUNCAO\_CARGO} \leftarrow \text{usuario\_interno} \bowtie_{cpf=cpf} \text{funcionario} \bowtie_{id\_cargo=id\_cargo} \text{cargo\_funcionario}
$$

$$
\text{JUNCAO\_USO} \leftarrow \text{JUNCAO\_CARGO} \bowtie_{cpf=cpf\_usuario} \text{uso\_dispositivo} \bowtie_{id\_dispositivo=id\_dispositivo} \text{dispositivo\_acesso}
$$

$$
\text{RESULTADO} \leftarrow \pi_{nome\_completo, nome\_cargo, tipo\_dispositivo, horario\_inicio}(\text{JUNCAO\_USO})
$$
