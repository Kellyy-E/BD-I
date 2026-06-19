### CONSULTAS INTERSEÇÃO, UNIAO, SUBTRACAO ###

### 1 - Todos os participantes de eventos(internos e externos)

$$
\text{PARTICIPANTES\_INTERNOS} \leftarrow 
\pi_{cpf, nome\_completo}
\left(
usuario\_interno \bowtie_{cpf = cpf\_participante} inscricao\_evento
\right)
$$

$$
\text{PARTICIPANTES\_EXTERNOS} \leftarrow 
\pi_{cpf, nome\_completo}
\left(
participante\_external \bowtie_{cpf = cpf\_participante} inscricao\_evento
\right)
$$

$$
\text{RESULTADO} \leftarrow 
\pi_{cpf, nome\_completo, 'Interno' \rightarrow tipo\_participante}(\text{PARTICIPANTES\_INTERNOS})
\cup
\pi_{cpf, nome\_completo, 'Externo' \rightarrow tipo\_participante}(\text{PARTICIPANTES\_EXTERNOS})
$$

### 2 - Usuarios internos que estao inscritos em pelo menos um evento

$$
\text{RESULTADO} \leftarrow 
\pi_{cpf}(usuario\_interno)
\cap
\pi_{cpf\_participante}(inscricao\_evento)
$$

### 3 - úsuarios que nunca se inscreveram em nenhum evento

$$
\text{USUARIOS\_INSCRITOS} \leftarrow 
\pi_{cpf, nome\_completo}
\left(
usuario\_interno \bowtie_{cpf = cpf\_participante} inscricao\_evento
\right)
$$

$$
\text{RESULTADO} \leftarrow 
\pi_{cpf, nome\_completo}(usuario\_interno)
-
\text{USUARIOS\_INSCRITOS}
$$

### 4 - CPFs de todos que tem vinculo ativo: emprestimo em aberto ou Inscrição em eventos futuros

$$
\text{EMPRESTIMOS\_ABERTOS} \leftarrow 
\sigma_{data\_efetiva\_devolucao \ IS \ NULL}(emprestimo)
$$

$$
\text{EVENTOS\_FUTUROS} \leftarrow 
\sigma_{data\_realizacao \geq CURRENT\_DATE}
(inscricao\_evento \bowtie evento)
$$

$$
\text{RESULTADO} \leftarrow 
\pi_{cpf\_usuario \rightarrow cpf, 'Emprestimo em aberto' \rightarrow vinculo}
(\text{EMPRESTIMOS\_ABERTOS})
\cup
\pi_{cpf\_participante \rightarrow cpf, 'Inscricao em evento futuro' \rightarrow vinculo}
(\text{EVENTOS\_FUTUROS})
$$
