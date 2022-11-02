/* Exercício 09 - Procedimentos Armazenados */

use lab09

CREATE TABLE TB_CLIENTE (
  CD_CLIENTE INT NOT NULL PRIMARY KEY,
  NM_CLIENTE VARCHAR(60) NOT NULL,
  CPF INT NULL,
  DT_NASCIMENTO DATETIME,
  TIPO_CLIENTE VARCHAR(40) NULL
)

INSERT INTO TB_CLIENTE VALUES(1,'JOAO',5444,'19760812',NULL)
INSERT INTO TB_CLIENTE VALUES(2,'CARLOS',3333,'19780812',NULL)
INSERT INTO TB_CLIENTE VALUES(3,'PATRICIA',6666,'19800712',NULL)

DELETE FROM TB_CLIENTE
SELECT * FROM TB_CLIENTE

CREATE TABLE TB_CONTA (
   NR_CONTA INT NOT NULL PRIMARY KEY,
   CD_CLIENTE INT NOT NULL,
   SALDO NUMERIC(10,2) NOT NULL,
)

INSERT INTO TB_CONTA VALUES(100, 1, 12000)
INSERT INTO TB_CONTA VALUES(200, 2, 2000)
INSERT INTO TB_CONTA VALUES(300, 2, 4000)
INSERT INTO TB_CONTA VALUES(400, 2, 1000)
INSERT INTO TB_CONTA VALUES(500, 3, 6000)

SELECT * FROM TB_CONTA

Criar um procedimento SP_CLASSIFICA_CLIENTE para classificar um Cliente como
NORMAL ou VIP. O procedimento deve receber como parâmetros de entrada a quantidade
de contas que o Cliente possui e a soma dos saldos de suas contas. O procedimento deve
apresentar um parâmetro de saída informando se o Cliente é NORMAL ou VIP. O cliente
será classificado de acordo com a seguinte regra:

Se o Saldo Total >= 10.000
   O Cliente é VIP
Se o Saldo Total >= 5.000 e < 10.000 e o Cliente Possuir mais de 2 contas
   O Cliente é VIP
Caso Contrário o Cliente é Normal.

CREATE OR ALTER PROCEDURE SP_CLASSIFICA_CLIENTE (@QTD_CONTAS INT, @SALDO NUMERIC(10,2),
                                        @CLASSIFICACAO VARCHAR(10) OUTPUT)
AS
BEGIN
IF @SALDO >= 10000.00
  SET @CLASSIFICACAO = 'VIP'
ELSE 
  IF @SALDO >= 5000.00 AND @QTD_CONTAS > 2
     SET @CLASSIFICACAO = 'VIP'
  ELSE
     SET @CLASSIFICACAO = 'NORMAL'
END
---------------------------------------------
-- Testando o procedimento


DECLARE @CLASSIFICACAO VARCHAR(10)

-- Vip
EXEC SP_CLASSIFICA_CLIENTE 1, 11000, @CLASSIFICACAO OUTPUT
PRINT @CLASSIFICACAO

-- Vip
EXEC SP_CLASSIFICA_CLIENTE 4, 6000, @CLASSIFICACAO OUTPUT
PRINT @CLASSIFICACAO

-- Normal
EXEC SP_CLASSIFICA_CLIENTE 1, 8000, @CLASSIFICACAO OUTPUT
PRINT @CLASSIFICACAO



2. Criar um procedimento SP_ATUALIZA_TIPO_CLENTE utilizando cursores para varrer
   a tabela TB_CLIENTE e, utilizando o procedimento desenvolvido da questão 1, atualizar
   o atributo TIPO_CLIENTE na tabela TB_CLIENTE para NORMAL ou VIP de acordo
   com as informações contidas na tabela TB_CONTA. 

CREATE OR ALTER PROCEDURE SP_ATUALIZA_TIPO_CLIENTE
AS 
BEGIN
DECLARE @CD_CLIENTE INT,
        @QTD_CONTAS INT,
        @SALDO NUMERIC(10,2), 
        @CLASSIFICACAO VARCHAR(10)

DECLARE C_CLIENTE CURSOR FOR
        SELECT CD_CLIENTE FROM TB_CLIENTE
OPEN C_CLIENTE
FETCH C_CLIENTE INTO @CD_CLIENTE
WHILE (@@FETCH_STATUS = 0)
  BEGIN
    SET @QTD_CONTAS = (SELECT COUNT(NR_CONTA) 
                       FROM TB_CONTA
                       WHERE CD_CLIENTE = @CD_CLIENTE)

    SET @SALDO = (SELECT ISNULL(SUM(SALDO),0) 
                  FROM TB_CONTA
                  WHERE CD_CLIENTE = @CD_CLIENTE)
    
    EXEC SP_CLASSIFICA_CLIENTE @QTD_CONTAS, @SALDO, @CLASSIFICACAO OUTPUT
   
    UPDATE TB_CLIENTE
    SET TIPO_CLIENTE = @CLASSIFICACAO
    WHERE CD_CLIENTE = @CD_CLIENTE
   
    FETCH C_CLIENTE INTO @CD_CLIENTE
  END
CLOSE C_CLIENTE
DEALLOCATE C_CLIENTE
END


----------------------------------------------------------------------------------
-- TESTANDO O PROCEDIMENTO

EXEC SP_ATUALIZA_TIPO_CLIENTE

SELECT * FROM TB_CLIENTE;
SELECT * FROM TB_CONTA;




