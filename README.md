/* Exclui o banco de dados "biblioteca", caso o banco de dados exista */
drop database biblioteca;


/* Cria o banco de dados "locadora", com definições com permitem a utilização de acentos e símbolos ("character set utf8mb4")
e a comparação entre caracteres acentuados e que não diferenciam maiúsculas e minúsculas ("utf8mb4_0900_ai_ci") */
create database biblioteca
character set utf8mb4
collate utf8mb4_0900_ai_ci;

/* Define o banco de dados locadora como o banco de dados atual */
use biblioteca;


/* Cria a tabela livro. */
CREATE TABLE livro (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    id_autor INT,
    id_categoria INT,
    ano_publicacao YEAR,
    exemplares_disponiveis INT
);

/* Cria a tabela autor. */
CREATE TABLE autor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nacionalidade VARCHAR(50),
    data_nascimento DATE
);


/* Cria a tabela membro */
CREATE TABLE membro(
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    telefone VARCHAR(20),
    endereco VARCHAR(255)
);

/* Cria a tabela categoria */
CREATE TABLE categoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50)
);

/* Cria a tabela empréstimo. */
CREATE TABLE emprestimo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_membro INT,
    id_livro INT,
    data_emprestimo DATE,
    data_devolucao DATE,
    FOREIGN KEY (id_membro) REFERENCES membro(id),
    FOREIGN KEY (id_livro) REFERENCES livro(id)
);

/* Insere registros na tabela filmes */
INSERT INTO livro (titulo, id_autor, id_categoria, ano_publicacao, exemplares_disponiveis) VALUES
('A Revolução dos Bichos', 1, 1, 1945, 44),
('Harry Potter e a Pedra Filosofal', 2, 2, 1997, 4),
('Assassinato no Expresso do Oriente', 3, 3, 1934, 2),
('Fundação', 4, 4, 1951, 8),
('O Senhor dos Anéis: A Sociedade do Anel', 5, 2, 1954, 10);

insert into categoria (nome) values
	('Ficção'),
	('Fantasia'),
	('Mistério'),
	('Ficção Científica'),
	('Romance');


INSERT INTO autor (nome, nacionalidade, data_nascimento) VALUES
    ('George Orwell', 'Britânico', '1903-06-25'),
    ('J.K. Rowling', 'Britânica', '1965-07-31'),
    ('Agatha Christie', 'Britânica', '1890-09-15'),
    ('Isaac Asimov', 'Americano', '1920-01-02'),
    ('J.R.R. Tolkien', 'Britânico', '1892-01-03');
    
INSERT INTO membro (nome, email, telefone, endereco) VALUES
    ('Ana Silva', 'ana@example.com', '123456789', 'Rua A, 123'),
    ('Bruno Santos', 'bruno@example.com', '987654321', 'Avenida B, 456'),
    ('Carlos Oliveira', 'carlos@example.com', '321654987', 'Praça C, 789'),
    ('Diana Ferreira', 'diana@example.com', '456789123', 'Rua D, 101'),
    ('Eduardo Costa', 'eduardo@example.com', '159753486', 'Avenida E, 202');
    
INSERT INTO emprestimo (id_membro, id_livro, data_emprestimo, data_devolucao) VALUES
(1, 1, '2023-10-01', '2023-10-15'),
(2, 2, '2023-10-02', NULL),  
(3, 3, '2023-10-03', '2023-10-18'),
(4, 4, '2023-10-04', NULL), 
(5, 5, '2023-10-05', '2024-10-05');

/* 4 - Listar todos os autores cujo nome inicia com a letra ‘A’.*/
select * from autor where nome like 'A%';

/* 5 - Listar todos os livros cujo título contenha a palavra ‘sistema’.*/
select * from livro where titulo like '%sistema%';

/* 6 - Listar a chave primária e o título dos livros que foram publicados há mais de 5 anos.*/
SELECT id, titulo 
FROM livro 
WHERE ano_publicacao < YEAR(CURDATE()) - 5;


/* 7 - Listar, em ordem alfabética por título, os livros que possuem menos de 5 exemplares disponíveis.*/
select titulo from livro where exemplares_disponiveis < 5 order by titulo asc;

/* 8 - */
SELECT * 
FROM livro 
WHERE id NOT IN (SELECT id_livro FROM emprestimo);

/* 9 - Mudar a data de devolução real de todos os empréstimos para a data atual. */
UPDATE emprestimo 
SET data_devolucao = CURDATE() 
WHERE data_devolucao IS NOT NULL;

describe livro;
describe autor;
describe membro;
describe categoria;
describe emprestimo;

select * from livro;
select * from autor;
select * from membro;
select * from categoria;
select * from emprestimo;

/* 10 - Postergar em um mês a data de devolução prevista de todos os empréstimos.*/
delete from membro where id not in (select distinct id_membro from emprestimo);


/* 11 - Excluir todos os membros que nunca fizeram empréstimo*/ 
DELETE FROM membro 
WHERE id NOT IN (SELECT DISTINCT id_membro FROM emprestimo);

/* 12 - Excluir todas as categorias que não aparecem em nenhum livro*/
DELETE FROM categoria 
WHERE id NOT IN (SELECT DISTINCT id_categoria FROM livro);


describe livro;
describe autor;
describe membro;
describe categoria;
describe emprestimo;

select * from livro;
select * from autor;
select * from membro;
select * from categoria;
select * from emprestimo;

/* PROVA A2 - 3 */

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


/* 4) Listar o título do livro, a data de empréstimo e a data da devolução de todos os livros da base. */
SELECT livro.titulo AS Título, emprestimo.data_emprestimo AS Data_de_Empréstimo, emprestimo.data_devolucao AS Data_de_Devolução
FROM livro
LEFT JOIN emprestimo ON livro.id = emprestimo.id_livro;


/* 5) Listar a data de empréstimo, data da devolução, nome do membro que emprestou, título do livro,
nome da categoria e nome do autor (ou autores) de todos os empréstimos realizados. */
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
