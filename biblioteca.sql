/*
ATIVIDADE AVALIATIVA

Dupla:
	Felipe Muniz da Rosa
    Gustavo Lascoscki
*/

/* PROVA A2 - 2 */

/*1) Criar a base de dados e prepará-la para uso: */
CREATE DATABASE IF NOT EXISTS biblioteca;

USE biblioteca;

/*2) Criar as tabelas de acordo com o modelo lógico relacional idealizado na avaliação anterior, considerando
as restrições de integridade; a base de dados deve conter pelo menos cinco tabelas, análogas a: livro,
autor, membro, categoria, empréstimo: */
CREATE TABLE autor (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(100) NOT NULL,
    descricao VARCHAR(255)
);

CREATE TABLE livro (
    id_livro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    ano INT,
    exemplares INT,
    id_autor INT,
    id_categoria INT,
    FOREIGN KEY (id_autor) REFERENCES autor(id_autor),
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

CREATE TABLE membro (
    id_membro INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(255),
    cpf CHAR(11) NOT NULL UNIQUE,
    telefone CHAR(11)
);

CREATE TABLE emprestimo (
    id_membro INT,
    id_livro INT,
    data_emprestimo DATE,
    data_devolucao_prevista DATE,
    data_devolucao_real DATE,
    PRIMARY KEY (id_membro, id_livro),
    FOREIGN KEY (id_membro) REFERENCES membro(id_membro),
    FOREIGN KEY (id_livro) REFERENCES livro(id_livro)
);

SHOW TABLES;

/*3) Inserir pelo menos 5 registros em cada tabela: */
INSERT INTO autor (nome) VALUES
	('Aldous Huxley'),
	('Agatha Christie'),
	('Isaac Asimov'),
	('Arthur C. Clarke'),
	('J.K. Rowling');
    

INSERT INTO categoria (tipo, descricao) VALUES
	('Ficção Científica', 'Livros que exploram conceitos futuristas e científicos.'),
	('Mistério', 'Livros que envolvem investigações e enigmas.'),
	('Fantasia', 'Livros que contêm elementos mágicos e mundos imaginários.'),
	('Clássicos', 'Obras literárias reconhecidas ao longo do tempo.'),
	('Não-ficção', 'Livros baseados em fatos reais.');

INSERT INTO livro (titulo, ano, exemplares, id_autor, id_categoria) VALUES
	('Admirável Mundo Novo', 1932, 3, 1, 1),
	('O Assassinato de Roger Ackroyd', 1926, 2, 2, 2),
	('Fundação', 1951, 5, 3, 1),
	('2001: Uma Odisseia no Espaço', 1968, 4, 4, 1),
	('Harry Potter e a Pedra Filosofal', 1997, 6, 5, 3);

INSERT INTO membro (nome, endereco, cpf, telefone) VALUES
	('João Silva', 'Rua A, 123', '12345678901', '12345678901'),
	('Maria Oliveira', 'Rua B, 456', '23456789012', '23456789012'),
	('Carlos Pereira', 'Rua C, 789', '34567890123', '34567890123'),
	('Ana Santos', 'Rua D, 101', '45678901234', '45678901234'),
	('Pedro Costa', 'Rua E, 202', '56789012345', '56789012345');

INSERT INTO emprestimo (id_livro, id_membro, data_emprestimo, data_devolucao_prevista, data_devolucao_real) VALUES
    (1, 1, '2024-10-05', '2024-11-01', NULL),
    (2, 2, '2024-10-09', '2024-11-05', NULL),
    (3, 3, '2024-10-14', '2024-11-10', NULL),
    (4, 4, '2024-10-19', '2024-11-15', NULL),
    (5, 5, '2024-10-24', '2024-11-20', NULL);

/*4) Listar todos os autores cujo nome inicia com a letra ‘A’: */
SELECT * FROM autor WHERE nome LIKE 'A%';

/*5) Listar todos os livros cujo título contenha a palavra ‘sistema’: */
SELECT * FROM livro WHERE titulo LIKE '%sistema%';

/*6) Listar a chave primária e o título dos livros que foram publicados há mais de 5 anos: */
SELECT id_livro, titulo FROM livro WHERE ano < YEAR(CURDATE()) - 5;

/*7) Listar, em ordem alfabética por título, os livros que possuem menos de 5 exemplares disponíveis: */
SELECT * FROM livro WHERE exemplares < 5 ORDER BY titulo;

/*8) Listar todos os livros que nunca foram emprestados: */
SELECT * FROM livro WHERE id_livro NOT IN (SELECT id_livro FROM emprestimo);

/*9) Mudar a data de devolução real de todos os empréstimos para a data atual: */
UPDATE emprestimo SET data_devolucao_real = CURRENT_DATE;

/*10) Postergar em um mês a data de devolução prevista de todos os empréstimos: */
UPDATE emprestimo SET data_devolucao_prevista = DATE_ADD(data_devolucao_prevista, INTERVAL 1 MONTH);

/*11) Excluir todos os membros que nunca fizeram empréstimo: */
DELETE FROM membro WHERE id_membro NOT IN (SELECT DISTINCT id_membro FROM emprestimo);

/*12) Excluir todas as categorias que não aparecem em nenhum livro: */
DELETE FROM categoria WHERE id_categoria NOT IN (SELECT DISTINCT id_categoria FROM livro);

/* PROVA A2 - 3 */

/* 1) Listar o título do livro e o nome do autor para todos os livros cadastrados na base. */
SELECT livro.titulo AS Título, autor.nome AS Autor
FROM livro
JOIN autor ON livro.id_autor = autor.id_autor;

/*2) Listar a data de empréstimo, o nome do membro que emprestou, e o título do livro de todos os
empréstimos feitos neste ano.*/
SELECT emprestimo.data_emprestimo AS Data_de_Empréstimo, membro.nome AS Membro, livro.titulo AS Livro
FROM emprestimo
JOIN membro ON emprestimo.id_membro = membro.id_membro
JOIN livro ON emprestimo.id_livro = livro.id_livro
WHERE YEAR(emprestimo.data_emprestimo) = YEAR(CURDATE());

/*3) Listar o nome da categoria e o título do livro de todos os livros cadastrados na base.*/
SELECT categoria.tipo AS Categoria, livro.titulo AS Título
FROM livro
JOIN categoria ON livro.id_categoria = categoria.id_categoria;

/*4) Listar o título do livro, a data de empréstimo e a data da devolução real de todos os livros da base.*/
SELECT livro.titulo AS Título, emprestimo.data_emprestimo AS Data_de_Empréstimo, emprestimo.data_devolucao_real AS Data_de_Devolução_Real
FROM livro
LEFT JOIN emprestimo ON livro.id_livro = emprestimo.id_livro;

/*5) Listar a data de empréstimo, data da devolução real, nome do membro que emprestou, título do livro,
nome da categoria e nome do autor (ou autores) de todos os empréstimos realizados.*/
SELECT emprestimo.data_emprestimo AS Data_de_Empréstimo,
       emprestimo.data_devolucao_real AS Data_de_Devolução_Real,
       membro.nome AS Membro,
       livro.titulo AS Livro,
       categoria.tipo AS Categoria,
       autor.nome AS Autor
FROM emprestimo
JOIN membro ON emprestimo.id_membro = membro.id_membro
JOIN livro ON emprestimo.id_livro = livro.id_livro
JOIN categoria ON livro.id_categoria = categoria.id_categoria
JOIN autor ON livro.id_autor = autor.id_autor;

/*6) Contar quantos livros estão cadastrados na base.*/
SELECT COUNT(*) AS Total_de_Livros FROM livro;

/*7) Contar quantos empréstimos foram feitos no ano passado.*/
SELECT COUNT(*) AS Empréstimos_Ano_Passado
FROM emprestimo
WHERE YEAR(data_emprestimo) = YEAR(CURDATE()) - 1;

/*8) Listar o nome da categoria e a quantidade de livros por categoria.*/
SELECT categoria.tipo AS Categoria, COUNT(livro.id_livro) AS Quantidade_de_Livros
FROM categoria
LEFT JOIN livro ON categoria.id_categoria = livro.id_categoria
GROUP BY categoria.tipo;

/*9) Listar o título do livro e o nome do membro de todos os livros emprestados na semana corrente,
agrupados e ordenados por data de empréstimo.*/
SELECT livro.titulo AS Livro, membro.nome AS Membro, emprestimo.data_emprestimo AS Data_de_Empréstimo
FROM emprestimo
JOIN livro ON emprestimo.id_livro = livro.id_livro
JOIN membro ON emprestimo.id_membro = membro.id_membro
WHERE WEEK(emprestimo.data_emprestimo) = WEEK(CURDATE()) AND YEAR(emprestimo.data_emprestimo) = YEAR(CURDATE())
ORDER BY emprestimo.data_emprestimo;

/*10) Listar o total de livros emprestados no ano atual, agrupados e ordenados cronologicamente por mês,
sendo que o nome do mês deve ser apresentado por extenso.*/
SELECT Mês, COUNT(*) AS Total_de_Empréstimos
FROM (
    SELECT DATE_FORMAT(data_emprestimo, '%M') AS Mês
    FROM emprestimo
    WHERE YEAR(data_emprestimo) = YEAR(CURDATE())
) AS Subquery
GROUP BY Mês
ORDER BY MONTH(STR_TO_DATE(Mês, '%M'));


