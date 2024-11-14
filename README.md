/*
ATIVIDADE AVALIATIVA

Dupla:
	Lucas Farias
    Joao Bender
*/

/* Exclui o banco de dados "biblioteca", caso o banco de dados exista */
DROP DATABASE IF EXISTS biblioteca;

/* Cria o banco de dados "biblioteca", com definições que permitem a utilização de acentos e símbolos ("character set utf8mb4") */
CREATE DATABASE biblioteca
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

/* Define o banco de dados biblioteca como o banco de dados atual */
USE biblioteca;

/* Cria a tabela livro */
CREATE TABLE livro (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    id_autor INT,
    id_categoria INT,
    ano_publicacao YEAR,
    exemplares_disponiveis INT,
    FOREIGN KEY (id_autor) REFERENCES autor(id),
    FOREIGN KEY (id_categoria) REFERENCES categoria(id)
);

/* Cria a tabela autor */
CREATE TABLE autor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nacionalidade VARCHAR(50),
    data_nascimento DATE
);

/* Cria a tabela categoria */
CREATE TABLE categoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50)
);

/* Cria a tabela membro */
CREATE TABLE membro (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    telefone VARCHAR(20),
    endereco VARCHAR(255)
);

/* Cria a tabela empréstimo */
CREATE TABLE emprestimo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_membro INT,
    id_livro INT,
    data_emprestimo DATE,
    data_devolucao DATE,
    FOREIGN KEY (id_membro) REFERENCES membro(id),
    FOREIGN KEY (id_livro) REFERENCES livro(id)
);

/* Insere registros na tabela autor */
INSERT INTO autor (nome, nacionalidade, data_nascimento) VALUES
    ('Aldous Huxley', 'Britânico', '1894-07-26'),
    ('Agatha Christie', 'Britânica', '1890-09-15'),
    ('Isaac Asimov', 'Americano', '1920-01-02'),
    ('Arthur C. Clarke', 'Britânico', '1917-12-16'),
    ('J.K. Rowling', 'Britânica', '1965-07-31');

/* Insere registros na tabela categoria */
INSERT INTO categoria (nome) VALUES
    ('Ficção Científica'),
    ('Mistério'),
    ('Fantasia'),
    ('Clássicos'),
    ('Não-ficção');

/* Insere registros na tabela livro */
INSERT INTO livro (titulo, id_autor, id_categoria, ano_publicacao, exemplares_disponiveis) VALUES
    ('Admirável Mundo Novo', 1, 1, 1932, 3),
    ('O Assassinato de Roger Ackroyd', 2, 2, 1926, 2),
    ('Fundação', 3, 1, 1951, 5),
    ('2001: Uma Odisseia no Espaço', 4, 1, 1968, 4),
    ('Harry Potter e a Pedra Filosofal', 5, 3, 1997, 6);

/* Insere registros na tabela membro */
INSERT INTO membro (nome, email, telefone, endereco) VALUES
    ('Ana Silva', 'ana@example.com', '123456789', 'Rua A, 123'),
    ('Bruno Santos', 'bruno@example.com', '987654321', 'Avenida B, 456'),
    ('Carlos Oliveira', 'carlos@example.com', '321654987', 'Praça C, 789'),
    ('Diana Ferreira', 'diana@example.com', '456789123', 'Rua D, 101'),
    ('Eduardo Costa', 'eduardo@example.com', '159753486', 'Avenida E, 202');

/* Insere registros na tabela empréstimo */
INSERT INTO emprestimo (id_membro, id_livro, data_emprestimo, data_devolucao) VALUES
    (1, 1, '2024-10-01', NULL),
    (2, 2, '2024-10-02', '2024-10-15'),
    (3, 3, '2024-10-03', NULL),
    (4, 4, '2024-10-04', '2024-10-18'),
    (5, 5, '2024-10-05', NULL);

/* Consultas e operações solicitadas */

/* 1) Listar o título do livro e o nome do autor para todos os livros cadastrados na base. */
SELECT livro.titulo AS Título, autor.nome AS Autor
FROM livro
JOIN autor ON livro.id_autor = autor.id;

/* 2) Listar a data de empréstimo, o nome do membro que emprestou, e o título do livro de todos os empréstimos feitos neste ano. */
SELECT emprestimo.data_emprestimo AS Data_de_Empréstimo, membro.nome AS Membro, livro.titulo AS Livro
FROM emprestimo
JOIN membro ON emprestimo.id_membro = membro.id
JOIN livro ON emprestimo.id_livro = livro.id
WHERE YEAR(emprestimo.data_emprestimo) = YEAR(CURDATE());

/* 3) Listar o nome da categoria e o título do livro de todos os livros cadastrados na base. */
SELECT categoria.nome AS Categoria, livro.titulo AS Título
FROM livro
JOIN categoria ON livro.id_categoria = categoria.id;

/* 4) Listar o título do livro, a data de empréstimo e a data da devolução real de todos os livros da base. */
SELECT livro.titulo AS Título, emprestimo.data_emprestimo AS Data_de_Empréstimo, emprestimo.data_devolucao AS Data_de_Devolução
FROM livro
LEFT JOIN emprestimo ON livro.id = emprestimo.id_livro;

/* 5) Listar a data de empréstimo, data da devolução real, nome do membro que emprestou, título do livro, nome da categoria e nome do autor (ou autores) de todos os empréstimos realizados. */
SELECT emprestimo.data_emprestimo AS Data_de_Empréstimo,
       emprestimo.data_devolucao AS Data_de_Devolução,
       membro.nome AS Membro,
       livro.titulo AS Livro,
       categoria.nome AS Categoria,
       autor.nome AS Autor
FROM emprestimo
JOIN membro ON emprestimo.id_membro = membro.id
JOIN livro ON emprestimo.id_livro = livro.id
JOIN categoria ON livro.id_categoria = categoria.id
JOIN autor ON livro.id_autor = autor.id;

/* 6) Contar quantos livros estão cadastrados na base. */
SELECT COUNT(*) AS Total_de_Livros FROM livro;

/* 7) Contar quantos empréstimos foram feitos no ano passado. */
SELECT COUNT(*) AS Empréstimos_Ano_Passado
FROM emprestimo
WHERE YEAR(data_emprestimo) = YEAR(CURDATE()) - 1;

/* 8) Listar o nome da categoria e a quantidade de livros por categoria. */
SELECT categoria.nome AS Categoria, COUNT(livro.id) AS Quantidade_de_Livros
FROM categoria
LEFT JOIN livro ON categoria.id = livro.id_categoria
GROUP BY categoria.nome;

/* 9) Listar o título do livro e o nome do membro de todos os livros emprestados na semana corrente, agrupados e ordenados por data de empréstimo. */
SELECT livro.titulo AS Livro, membro.nome AS Membro, emprestimo.data_emprestimo AS Data_de_Empréstimo
FROM emprestimo
JOIN livro ON emprestimo.id_livro = livro.id
JOIN membro ON emprestimo.id_membro = membro.id
WHERE WEEK(emprestimo.data_emprestimo, 1) = WEEK(CURDATE(), 1)
  AND YEAR(emprestimo.data_emprestimo) = YEAR(CURDATE())
ORDER BY emprestimo.data_emprestimo;

/* 10) Listar o total de livros emprestados no ano atual, agrupados e ordenados cronologicamente por mês. */
SELECT MONTHNAME(data_emprestimo) AS Mês, COUNT(*) AS Total_de_Empréstimos
FROM emprestimo
WHERE YEAR(data_emprestimo) = YEAR(CURDATE())
GROUP BY MONTH(data_emprestimo), MONTHNAME(data_emprestimo)
ORDER BY MONTH(data_emprestimo);
