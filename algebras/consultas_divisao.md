### 1. Usuários inscritos em TODAS as Palestras

PALESTRAS ← πid_evento​(σtipo_evento=’Palestra’​(evento))
INSCRICOES_PALESTRA ← πcpf_participante, id_evento​(inscricao_evento⋉PALESTRAS)
USUARIOS_TODAS_PALESTRAS←INSCRICOES_PALESTRA ÷ PALESTRAS


### 2. Usuários que pegaram empréstimo de TODOS os exemplares de uma obra

EXEMPLARES_OBRA←πid_exemplar​(σid_obra=1​(exemplar_fisico))
EMPRESTIMOS_OBRA←πcpf_usuario, id_exemplar​(emprestimo⋉EXEMPLARES_OBRA)
USUARIOS_TODOS_EXEMPLARES←EMPRESTIMOS_OBRA÷EXEMPLARES_OBRA