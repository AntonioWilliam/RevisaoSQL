create database ex005 
GO
USE ex005
GO

CREATE TABLE Cliente(
    CPF char(12)  NOT NULL,
    Nome varchar (50) NOT NULL,
    Telefone int NOT NULL,
    PRIMARY KEY (CPF)
)
GO

ALTER TABLE Cliente
ALTER COLUMN Telefone char(9) NOT NULL

CREATE TABLE Fornecedor(
    ID int  NOT NULL,
    Nome varchar (50) NOT NULL,
    Logradouro varchar (60) NOT NULL,
    Nº int NOT NULL,
    Complemento varchar (30) NOT NULL,
    Cidade varchar (30) NOT NULL
    PRIMARY KEY (ID)
)
GO

CREATE TABLE Produto(
    Codigo int PRIMARY KEY NOT NULL,
    Descrição varchar (60) NOT NULL,
    Fornecedor int,
    Preço decimal (7, 2) NOT NULL,
    FOREIGN KEY (Fornecedor) REFERENCES Fornecedor(ID)
)
GO

CREATE TABLE Venda(
    Codigo int NOT NULL,
    Produto int NOT NULL,
    Cliente char(12) NOT NULL,
    Quantidade int NOT NULL,
    Valor_Total decimal (7, 2) NOT NULL,
    Data_venda date NOT NULL,
    PRIMARY KEY (Codigo, Produto, Cliente),
    FOREIGN KEY (Produto) REFERENCES Produto(Codigo),
    FOREIGN KEY (Cliente) REFERENCES Cliente(CPF)
)
GO

select * from Cliente
select * from Produto
select * from Fornecedor
select * from Venda

-- Consultar no formato dd/mm/aaaa: Data da venda 4

SELECT CONVERT(char(10),v.Data_venda,103) as DATA_VENDA
FROM Venda v
WHERE v.Codigo = 4 

-- Inserir na tabela fornecedor, a coluna Telefone e os seguintes dados
-- 1 - 7216-5371
-- 2 - 8715-3738
-- 4 - 3654-6289

ALTER TABLE Fornecedor 
ADD telefone char(9) NULL

UPDATE Fornecedor
set telefone = '7216-5371'
where ID = 1

UPDATE Fornecedor
set telefone = '8715-3738'
where ID = 2

UPDATE Fornecedor
set telefone = '3654-6289'
where ID = 4

-- Consultar por ordem alfabética de 
--nome, o nome, o enderço concatenado 
--e o telefone dos fornecedores

SELECT f.Nome, (f.Logradouro + ', N° '+ CAST(f.Nº as varchar(10)) + ', ' + f.Complemento + ' , ' + f.Cidade ) AS Endereco,   
		f.telefone
FROM Fornecedor f
ORDER BY f.Nome

--Produto, quantidade e valor total do comprado por Julio Cesar

SELECT v.Produto,v.Quantidade,v.Valor_Total
FROM Cliente c inner join Venda v ON c.CPF = v.Cliente
WHERE c.Nome like 'Julio Ces%'

-- Data, no formato dd/mm/aaaa
--e valor total do produto comprado por  Paulo Cesar

SELECT CONVERT(char(10),v.Data_venda, 103) AS DATA_VENDA, v.Valor_Total
FROM Cliente c inner join Venda v ON c.CPF = v.Cliente
WHERE c.Nome like 'Paulo Ces%'

--Consultar, em ordem decrescente, 
--o nome e o preço de todos os produtos 

SELECT p.Descrição,p.Preço
FROM produto p
ORDER BY p.Descrição,p.Preço DESC