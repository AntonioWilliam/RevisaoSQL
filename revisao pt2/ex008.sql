CREATE DATABASE ex008
GO
USE ex008
GO

CREATE TABLE motorista (
codigo		 int IDENTITY(12341,1) NOT NULL,
nome		 varchar(70) NOT NULL,
dataNasc	 date NOT NULL,
naturalidade varchar(30) NOT NULL
PRIMARY KEY (codigo)
)
GO

CREATE TABLE onibus (
placa		varchar(15) NOT NULL,
marca		varchar(20)NOT NULL,		
ano			int NOT NULL,
descricao	varchar(20) NOT NULL
PRIMARY KEY (placa)
)
GO
CREATE TABLE viagem (
codigo			int IDENTITY(101,1) NOT NULL,
placa		    varchar(15) NOT NULL,
motorista		int  NOT NULL,
horaSaida		int NOT NULL,
horaChegada		int NOT NULL,
Destino         varchar(30) NOT NULL
PRIMARY KEY (codigo),
FOREIGN KEY (placa) REFERENCES onibus(placa),
FOREIGN KEY (motorista) REFERENCES motorista(codigo)
)
GO

DROP TABLE motorista
DROP table viagem
DROP table onibus

SELECT * FROM motorista
SELECT * FROM onibus
SELECT * FROM viagem

-- Consultar, da tabela viagem, todas as horas de chegada e saída, 
--convertidas em formato HH:mm (108) e seus destinos

SELECT CAST(v.horaSaida as varchar(2)) + ' h' as horaSaida, 
		CAST(v.horaChegada as varchar(2)) + ' h' as horaChegada,
		v.destino
FROM viagem v

-- Consultar, com subquery, o nome do motorista que viaja para Sorocaba

SELECT m.nome
FROM motorista m
where m.codigo IN(
	SELECT motorista 
	FROM viagem 
	WHERE destino = 'Sorocaba'
)

-- Consultar, com subquery, a descrição do ônibus que vai para o Rio de Janeiro

SELECT  o.descricao
FROM onibus o
WHERE o.placa IN (
	SELECT placa
	FROM viagem 
	WHERE destino = 'Rio de Janeiro'
)

-- Consultar, com Subquery, a descrição, a marca e o ano do ônibus dirigido por Luiz Carlos

SELECT o.descricao, o.marca, m.nome
FROM onibus o, motorista m, viagem v
WHERE o.placa = v.placa
	and v.motorista = m.codigo
	and m.nome IN (
	SELECT nome
	FROM motorista
	WHERE nome= 'Luiz Carlos'
	)

--Consultar o nome, a idade e a naturalidade dos motoristas com mais de 30 anos

SELECT m.nome, DATEDIFF(YEAR, m.dataNasc, getDate()) AS Anos 
FROM motorista m
WHERE DATEDIFF(YEAR, m.dataNasc, getDate()) > 30


