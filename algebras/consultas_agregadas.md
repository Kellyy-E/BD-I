## 1. Total de empréstimos e multa acumulada por usuário

$$
\text{EMPRESTIMOS\_USUARIO} \leftarrow 
\text{usuario\_interno} \bowtie_{cpf = cpf\_usuario} \text{emprestimo}
$$

$$
\begin{aligned}
\text{RESULTADO} \leftarrow 
\mathcal{F}_{nome\_completo}\big(
&\text{COUNT}(id\_emprestimo) \rightarrow total\_emprestimos, \\
&\text{SUM}(multa\_atraso) \rightarrow multa\_total, \\
&\text{AVG}(multa\_atraso) \rightarrow multa\_media\big)
(\text{EMPRESTIMOS\_USUARIO})
\end{aligned}
$$


### 2 - Número de obras por autor e idioma

$$
\text{AUTOR\_OBRA} \leftarrow \text{autor} \bowtie_{id\_author=id\_author} \text{obra\_autor}
$$

$$
\text{AUTOR\_OBRA\_IDIOMA} \leftarrow \text{AUTOR\_OBRA} \bowtie_{id\_obra=id\_obra} \text{obra}
$$

$$
\text{RESULTADO} \leftarrow \mathcal{F}_{nome\_autor,\ idioma}
(\text{COUNT}(id\_obra) \rightarrow total\_obras)
(\text{AUTOR\_OBRA\_IDIOMA})
$$

### 3 - Obras com mais de um autor cadastrado na tabela obra_autor
$$
\text{OBRAS\_AUTORES} \leftarrow \text{obra} \bowtie_{id\_obra=id\_obra} \text{obra\_autor}
$$

$$
\text{AGRUPAMENTO} \leftarrow \mathcal{F}_{id\_obra,\ titulo,\ editora,\ ano\_publicacao}
(\text{COUNT}(id\_author) \rightarrow total\_autores)
(\text{OBRAS\_AUTORES})
$$

$$
\text{RESULTADO} \leftarrow \sigma_{total\_autores > 1}(\text{AGRUPAMENTO})
$$

### 4 - total de inscrições por evento e tipo, como nome do local
$$
\text{EVENTO\_LOCAL} \leftarrow \text{evento} \bowtie_{id\_local=id\_local} \text{local\_evento}
$$

$$
\text{EVENTO\_INSCRICAO} \leftarrow \text{EVENTO\_LOCAL} \bowtie_{id\_evento=id\_evento} \text{inscricao\_evento}
$$

$$
\text{RESULTADO} \leftarrow \mathcal{F}_{id\_evento,\ tipo\_evento,\ tema\_abordado,\ predio}
(\text{COUNT}(cpf\_participante) \rightarrow total\_inscritos)
(\text{EVENTO\_INSCRICAO})
$$

### 5 - Quantidade de exemplares fisicos por obra e por status de disponibilidade
$$
\text{OBRA\_EXEMPLAR} \leftarrow \text{obra} \bowtie_{id\_obra=id\_obra} \text{exemplar\_fisico}
$$

$$
\text{RESULTADO} \leftarrow \mathcal{F}_{titulo,\ status\_disponibilidade}
(\text{COUNT}(id\_exemplar) \rightarrow qtd\_exemplares)
(\text{OBRA\_EXEMPLAR})
$$

### 6 - Capacidade total e média dos locais de evento agrupados por prédio
$$
\begin{aligned}
\text{RESULTADO} \leftarrow \mathcal{F}_{predio}\big(
&\text{COUNT}(id\_local) \rightarrow total\_salas, \\
&\text{SUM}(capacidade\_maxima) \rightarrow capacidade\_total, \\
&\text{AVG}(capacidade\_maxima) \rightarrow capacidade\_media, \\
&\text{MAX}(capacidade\_maxima) \rightarrow maior\_capacidade, \\
&\text{MIN}(capacidade\_maxima) \rightarrow menor\_capacidade\big)
(\text{local\_evento})
\end{aligned}
$$

### 7 - Quantidade de eventos por tipo e público-alvo
$$
\begin{aligned}
\text{AGRUPAMENTO} \leftarrow \mathcal{F}_{tipo\_evento,\ publico\_alvo}\big(
&\text{COUNT}(id\_evento) \rightarrow total\_eventos, \\
&\text{MIN}(data\_realizacao) \rightarrow primeiro\_evento, \\
&\text{MAX}(data\_realizacao) \rightarrow ultimo\_evento\big)
(\text{evento})
\end{aligned}
$$

$$
\text{RESULTADO} \leftarrow \sigma_{total\_eventos > 1}(\text{AGRUPAMENTO})
$$