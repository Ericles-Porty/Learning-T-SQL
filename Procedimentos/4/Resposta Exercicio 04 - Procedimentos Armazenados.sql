CREATE database lab04

use lab04

select db_name()


---------------------------------------------------------------------------

1. Criar uma tabela TB_CLIENTE com a seguinte estrutura:

MATRICULA INT
NOME VARCHAR(40)
TELEFONE VARCHAR(10)

CREATE TABLE TB_CLIENTE (
	MATRICULA INT NOT NULL PRIMARY KEY,
	NOME VARCHAR(40) NOT NULL,
	TELEFONE VARCHAR(10)  NULL
)

------------------------------------------------------------------------------


2. Criar um procedimento armazenado, SP_INCLUI_CLIENTE, para incluir um novo
   Cliente. O procedimento deve apresentar como parâmetros de entrada a Matrícula, 
   o Nome e o Telefone do Cliente a ser incluído.


-- Solução   

CREATE OR ALTER PROCEDURE SP_INCLUI_CLIENTE (@MATRICULA INT, 
                                             @NOME VARCHAR(40),
				                             @TELEFONE VARCHAR(10))
AS
BEGIN 
   INSERT INTO TB_CLIENTE (MATRICULA, NOME, TELEFONE)
   VALUES (@MATRICULA, @NOME, @TELEFONE)
END

-- TESTE

EXEC SP_INCLUI_CLIENTE 1, 'JOAO', '234-8833'

SELECT * FROM TB_CLIENTE


-- Soluçao 02 (Com tratamento de erros e exceções)

CREATE OR ALTER PROCEDURE SP_INCLUI_CLIENTE (@MATRICULA INT, 
                                             @NOME VARCHAR(40),
				                             @TELEFONE VARCHAR(10),
				                             @RESULTADO INT OUTPUT,
				                             @MENSAGEM VARCHAR(100) OUTPUT)
AS
BEGIN 
   IF EXISTS (SELECT 1 FROM TB_CLIENTE 
              WHERE MATRICULA = @MATRICULA)
   BEGIN
	  SET @RESULTADO = 0
	  SET @MENSAGEM = 'MATRICULA JÁ EXISTE'
	  RETURN
   END
   INSERT INTO TB_CLIENTE (MATRICULA, NOME, TELEFONE)
   VALUES (@MATRICULA, @NOME, @TELEFONE)
   SET @RESULTADO = 1
   SET @MENSAGEM = 'CLIENTE INCLUIDO COM SUCESSO'
END

-- TESTE

DECLARE @RESULTADO INT,
        @MENSAGEM VARCHAR(100)

EXEC SP_INCLUI_CLIENTE 2, 'CARLOS', '5555-8833', 
                       @RESULTADO OUTPUT, @MENSAGEM OUTPUT

PRINT @RESULTADO
PRINT @MENSAGEM

DELETE FROM TB_CLIENTE
SELECT * FROM TB_CLIENTE

------------------------------------------------------------------------------

3. Criar um procedimento armazenado, SP_ALTERA_CLIENTE, para alterar as
   informações (Nome e Telefone) de um Cliente cadastrado. O procedimento deve
   apresentar como parâmetros de entrada a Matrícula, o Nome e o Telefone do Cliente.

CREATE OR ALTER PROCEDURE SP_ALTERA_CLIENTE (@MATRICULA INT, 
                                    @NOME VARCHAR(40),
				                    @TELEFONE VARCHAR(10)
				                    )
AS
BEGIN
   UPDATE TB_CLIENTE 
   SET NOME = @NOME,
       TELEFONE = @TELEFONE
   WHERE MATRICULA = @MATRICULA
END


SELECT * FROM TB_CLIENTE 

EXEC SP_ALTERA_CLIENTE 1, 'ANDRE VINICIUS', '999-9999'

--------------------------------------------------------------------------------

4. Criar um procedimento armazenado, SP_REMOVE_CLIENTE, para remover um Cliente
   cadastrado. O procedimento deve apresentar como parâmetro de entrada a Matrícula do
   Cliente a ser removido e como parâmetro de saída um valor inteiro para indicar se a
   remoção foi executado com sucesso. O parâmetro de saída deve retornar 1 se o cliente foi
   encontrado e removido, e 0 se não foi encontrado.


CREATE OR ALTER PROCEDURE SP_REMOVE_CLIENTE (@MATRICULA INT, @RESULTADO INT OUTPUT)
AS
BEGIN
   DELETE FROM TB_CLIENTE
   WHERE MATRICULA = @MATRICULA
   SELECT @RESULTADO = @@ROWCOUNT
END

-- TESTE

DECLARE @RESULTADO INT
EXEC SP_REMOVE_CLIENTE 2, @RESULTADO OUTPUT 
IF @RESULTADO = 1
   PRINT 'CLIENTE REMOVIDO'
ELSE 
   PRINT 'CLIENTE NAO ENCONTRADO'
   
SELECT * FROM TB_CLIENTE   

---------------------------------------------------------------------------

5. Alterar o procedimento SP_ALTERA_CLIENTE para adicionar a seguinte 
   funcionalidade:
   Se o valor do parâmetro passado for nulo (NULL) o atributo correspondente 
   não deve ser modificado.
   
   
CREATE OR ALTER PROCEDURE SP_ALTERA_CLIENTE (@MATRICULA INT, 
                                    @NOME VARCHAR(40),
				                    @TELEFONE VARCHAR(10)
				                    )
AS
BEGIN
   UPDATE TB_CLIENTE 
   SET NOME     = ISNULL(@NOME, NOME),
       TELEFONE = ISNULL(@TELEFONE, TELEFONE)
   WHERE MATRICULA = @MATRICULA
END

EXEC SP_ALTERA_CLIENTE 1, 'ANDRE SANTOS', NULL

SELECT * FROM TB_CLIENTE






