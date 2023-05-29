CREATE DATABASE ex002
GO
USE ex002
GO

create table aluno (
RA int  NOT NULL IDENTITY(12345,1),
nome varchar(50) NOT NULL,
sobrenome varchar(50) NOT NULL,
rua varchar(100) NOT NULL,
N int NOT NULL,
bairro varchar(50) NOT NULL,
CEP CHAR(8) NOT NULL,
telefone CHAR(8) NULL
primary key (RA)
)

create table cursos (
codigo int not null IDENTITY(1,1),
nome varchar(30) not null,
cargaHoraria varchar(10) not null,
turno varchar (10) not null
primary key (codigo)
)


create table disciplinas (
codigo int not null IDENTITY(1,1),
nome varchar(30) not null,
cargaHoraria varchar(10) not null,
turno varchar (10) not null,
semestre int not null
primary key (codigo)
)

SELECT * FROM disciplinas
SELECT * FROM cursos
SELECT * FROM aluno

--Consultas

--01 Nome e sobrenome, como nome complemento dos Alunos matriculados

SELECT a.nome + ' ' + a.sobrenome as NomeCompleto
FROM aluno a

-- 02 Rua, n°, Bairro, Cep como endereço do aluno que não tenha telefone

SELECT a.rua,a.N,a.bairro,a.CEP
FROM aluno a
WHERE a.telefone  like ''

--03 Telefone do aluno com RA12348

SELECT a.nome, a.RA, SUBSTRING(a.telefone,1,4) + '-' + SUBSTRING(a.telefone,5,8) as telefone 
FROM aluno a
WHERE a.RA like '12348%'

--04 Nome e turno dos cursos com 2800 horas

SELECT c.nome,c.turno
FROM cursos c
WHERE c.cargaHoraria like '2800%'

--05 O semestre do curso de Banco de Dados I noite

SELECT d.semestre
FROM disciplinas d
WHERE d.nome like 'Banco de Dados I%'
	