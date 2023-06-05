CREATE DATABASE ex006
GO
USE ex006
GO
CREATE TABLE editora (
codigo            INT                NOT NULL,
nome            VARCHAR(30)        NOT NULL,
site            VARCHAR(40)        NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE autor (
codigo            INT                NOT NULL,
nome            VARCHAR(30)        NOT NULL,
biografia        VARCHAR(100)    NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE estoque (
codigo            INT                NOT NULL,
nome            VARCHAR(100)    NOT NULL    UNIQUE,
quantidade        INT                NOT NULL,
valor            DECIMAL(7,2)    NOT NULL    CHECK(valor > 0.00),
codEditora        INT                NOT NULL,
codAutor        INT                NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (codEditora) REFERENCES editora (codigo),
FOREIGN KEY (codAutor) REFERENCES autor (codigo)
)
GO
CREATE TABLE compra (
codigo            INT                NOT NULL,
codEstoque        INT                NOT NULL,
qtdComprada        INT                NOT NULL,
valor            DECIMAL(7,2)    NOT NULL,
dataCompra        DATE            NOT NULL
PRIMARY KEY (codigo, codEstoque, dataCompra)
FOREIGN KEY (codEstoque) REFERENCES estoque (codigo)
)
GO
INSERT INTO editora VALUES
(1,'Pearson','www.pearson.com.br'),
(2,'Civilização Brasileira',NULL),
(3,'Makron Books','www.mbooks.com.br'),
(4,'LTC','www.ltceditora.com.br'),
(5,'Atual','www.atualeditora.com.br'),
(6,'Moderna','www.moderna.com.br')
GO
INSERT INTO autor VALUES
(101,'Andrew Tannenbaun','Desenvolvedor do Minix'),
(102,'Fernando Henrique Cardoso','Ex-Presidente do Brasil'),
(103,'Diva Marília Flemming','Professora adjunta da UFSC'),
(104,'David Halliday','Ph.D. da University of Pittsburgh'),
(105,'Alfredo Steinbruch','Professor de Matemática da UFRS e da PUCRS'),
(106,'Willian Roberto Cereja','Doutorado em Lingüística Aplicada e Estudos da Linguagem'),
(107,'William Stallings','Doutorado em Ciências da Computacão pelo MIT'),
(108,'Carlos Morimoto','Criador do Kurumin Linux')
GO
INSERT INTO estoque VALUES
(10001,'Sistemas Operacionais Modernos ',4,108.00,1,101),
(10002,'A Arte da Política',2,55.00,2,102),
(10003,'Calculo A',12,79.00,3,103),
(10004,'Fundamentos de Física I',26,68.00,4,104),
(10005,'Geometria Analítica',1,95.00,3,105),
(10006,'Gramática Reflexiva',10,49.00,5,106),
(10007,'Fundamentos de Física III',1,78.00,4,104),
(10008,'Calculo B',3,95.00,3,103)
GO
INSERT INTO compra VALUES
(15051,10003,2,158.00,'04/07/2021'),
(15051,10008,1,95.00,'04/07/2021'),
(15051,10004,1,68.00,'04/07/2021'),
(15051,10007,1,78.00,'04/07/2021'),
(15052,10006,1,49.00,'05/07/2021'),
(15052,10002,3,165.00,'05/07/2021'),
(15053,10001,1,108.00,'05/07/2021'),
(15054,10003,1,79.00,'06/08/2021'),
(15054,10008,1,95.00,'06/08/2021')

SELECT * FROM editora
SELECT * FROM autor
SELECT * FROM estoque
SELECT * FROM compra

--1) Consultar nome, valor unitário, nome da editora e
--nome do autor dos livros do estoque que foram vendidos. 
--Não podem haver repetições.
SELECT e.nome,e.valor,
	   ed.nome,a.nome
FROM estoque e INNER JOIN compra c ON e.codigo = c.codEstoque
			   INNER JOIN autor  a ON e.codAutor = a.codigo
			   INNER JOIN editora ed ON e.codEditora = ed.codigo 

--2) Consultar nome do livro, quantidade comprada e valor de compra da compra 15051
select * from compra
SELECT e.nome,c.qtdComprada,c.valor
FROM estoque e inner join compra c ON e.codigo = c.codEstoque 
WHERE c.codigo = 15051

--3) Consultar Nome do livro e site da editora dos livros da Makron books
--(Caso o site tenha mais de 10 dígitos, remover o www.).
select * from estoque
select * from editora

SELECT e.nome, SUBSTRING(ed.site,5,13) as Site
FROM estoque e inner join editora ed ON e.codEditora = ed.codigo
WHERE ed.nome like 'Makr%'

--4) Consultar nome do livro e Breve Biografia do David Halliday

SELECT e.nome, a.biografia
FROM estoque e inner join autor a ON e.codAutor = a.codigo
WHERE a.nome like 'David H%'

--5) Consultar código de compra e quantidade comprada 
--do livro Sistemas Operacionais Modernos
select * from compra
SELECT c.codigo, c.qtdComprada
FROM estoque e inner join compra c ON e.codigo = c.codEstoque
WHERE e.nome like 'Sistemas Operacionais Modernos'

--6) Consultar quais livros não foram vendidos    
select * from compra
select * from estoque

SELECT *
FROM estoque e left join compra c ON e.codigo = c.codEstoque
WHERE c.qtdComprada is null

--7) Consultar quais livros foram vendidos e não estão cadastrados
select * from compra
select * from estoque

SELECT e.nome
FROM estoque e INNER JOIN compra c ON e.codigo = c.codEstoque
WHERE e.codEditora is null

--8) Consultar Nome e site da editora que não tem Livros no estoque 
--(Caso o site tenha mais de 10 dígitos, remover o www.)
select * from editora
select * from estoque

SELECT ed.nome, SUBSTRING(ed.site,5,14)
FROM editora ed LEFT JOIN estoque e ON ed.codigo = e.codEditora
WHERE e.quantidade is null

--9) Consultar Nome e biografia do autor que não tem Livros no estoque 
--(Caso a biografia inicie com Doutorado, substituir por Ph.D.)    

select * from autor
select * from estoque

SELECT a.nome,
    CASE WHEN(a.biografia like 'Doutorado%')THEN 
    'Ph.D.' + SUBSTRING(a.biografia,8,LEN(a.biografia))
    else 
        a.biografia
        end AS Bio
FROM estoque e RIGHT JOIN autor a ON e.codAutor = a.codigo
WHERE e.quantidade is null

--10) Consultar o nome do Autor, e o maior valor de Livro no estoque.
--Ordenar por valor descendente    

select a.nome, e.valor
from autor a, estoque e
where a.codigo = e.codAutor
    and e.valor IN
(
SELECT MAX(valor)
FROM estoque
)

--11) Consultar o código da compra, o total de livros comprados 
--e a soma dos valores gastos. Ordenar por Código da Compra ascendente.    
select * from compra

SELECT c.codigo, SUM(c.qtdComprada) as QTDcomprada, SUM(c.valor) as Valortotal
FROM compra c
Group by c.codigo
order by c.codigo

--12) Consultar o nome da editora e a média de preços dos livros em estoque. 
--Ordenar pela Média de Valores ascendente.    

SELECT * FROM editora
SELECT * FROM estoque

SELECT ed.nome, CONVERT(decimal(7,2), AVG(e.valor)) AS media 
FROM editora ed INNER JOIN estoque e ON ed.codigo = e.codEditora
WHERE ed.codigo = e.codEditora
GROUP BY ed.nome 
ORDER BY ed.nome ASC

--13) Consultar o nome do Livro, a quantidade em estoque o nome da editora, 
--o site da editora (Caso o site tenha mais de 10 dígitos, remover o www.), 
--criar uma coluna status onde: 
	--Caso tenha menos de 5 livros em estoque, escrever Produto em Ponto de Pedido
    --Caso tenha entre 5 e 10 livros em estoque, escrever Produto Acabando
    --Caso tenha mais de 10 livros em estoque, escrever Estoque Suficiente
    --A Ordenação deve ser por Quantidade ascendente

SELECT e.nome, e.quantidade, ed.nome, SUBSTRING(ed.site,5,LEN(ed.site)),
	CASE WHEN e.quantidade < 5 THEN 'Produto em ponto de Pedido'
		 WHEN e.quantidade >=5 and e.quantidade <=10 THEN 'Produto acabando'
		 WHEN e.quantidade >10 THEN 'Estoque Suficiente'
	END as Status
FROM estoque e INNER JOIN editora ed ON e.codEditora = ed.codigo
ORDER BY e.quantidade ASC

--14) Para montar um relatório, é necessário montar uma consulta com a 
--seguinte saída: Código do Livro, Nome do Livro, Nome do Autor, 
--Info Editora (Nome da Editora + Site) de todos os livros    
	--Só pode concatenar sites que não são nulos
SELECT * FROM editora
SELECT * FROM estoque
SELECT * FROM autor

SELECT e.codigo,e.nome,
	   a.nome,
	   (ed.nome + ' - ' + ed.site) AS NomeSite
FROM estoque e INNER JOIN editora ed ON e.codEditora = ed.codigo
			   INNER JOIN autor a ON e.codAutor = a.codigo

--15) Consultar Codigo da compra, quantos dias da compra até hoje
--e quantos meses da compra até hoje
SELECT * FROM compra

SELECT c.codigo, 
	DATEDIFF(DAY,c.dataCompra,GETDATE())AS dias,
	DATEDIFF(MONTH,c.dataCompra,GETDATE())AS Meses
FROM compra c

--16) Consultar o código da compra e a soma dos valores gastos das compras que
--somam mais de 200.00   
SELECT * FROM compra

SELECT c.codigo, SUM(c.valor) AS ValorTotal
FROM compra c
GROUP BY c.codigo
HAVING SUM(c.valor) > 200


