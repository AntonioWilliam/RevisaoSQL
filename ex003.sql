use ex003


select * from cliente
select * from carro
select * from pecas
select * from servico

create table servico(
carro VARCHAR(10) NOT NULL,
peca int NOT NULL,
quantidade int NOT NULL,
valor int NOT NULL,
dataS date not null 
primary key (carro,peca,dataS),
foreign key (carro) references carro(placa),
foreign key (peca)  references pecas(codigo)
)
GO

-- 01 Telefone do dono do carro Ka, azul

SELECT c.nome, c.telefone
FROM cliente c inner join carro car ON car.placa = c.carro
WHERE car.cor like 'Azul%'
	and car.modelo like 'Ka%'

-- 02 Endereço concatenado do cliente que fez o serviço do dia 02/08/2009	

--SELECT CONVERT(CHAR(10), s.dataS, 103) AS hoje Exibe um DATE DD/MM/AAAA (BR)
--FROM servico s


SELECT (c.logadouro + ' ,N° ' + CAST(c.n as varchar)) as Endereço,  CONVERT(CHAR(10), s.dataS, 103) AS dataFormatada
FROM servico s inner join cliente c 
	on c.carro = s.carro
	WHERE 
	s.dataS like '2020-08-02%'
	

--03 Consultar Placas dos carros de anos anteriores a 2001

SELECT *
FROM carro c
WHERE c.ano < 2001

--04 Consultar marca, modelo,cor, concatenado dos carros posteriores a 2005

SELECT (c.marca + ' ' + c.modelo + ' ' + c.cor) as Carro
FROM carro c
WHERE c.ano > 2005

-- 05 Código e nome das peças que cust6am menos de R$80,00

SELECT p.nome,p.codigo
FROM pecas p
WHERE p.valor < 80