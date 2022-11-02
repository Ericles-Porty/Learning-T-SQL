CREATE TABLE TB_VENDAS (
   CD_VENDA INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   DT_VENDA DATETIME NOT NULL,
   CD_PRODUTO INT NOT NULL,
   QUANTIDADE INT NOT NULL,
   VALOR NUMERIC(10,2) NOT NULL
)

GO
CREATE OR ALTER TRIGGER TG_IMPEDE_ALTERACOES_NA_TB_VENDAS_EM_DETERMINADO_HORARIO
ON TB_VENDAS
AFTER INSERT,UPDATE,DELETE
AS
BEGIN
	DECLARE @HORA_ATUAL INT
	SET @HORA_ATUAL = DATEPART(HOUR,GETDATE())

	IF (@HORA_ATUAL >= 12 AND @HORA_ATUAL < 14) OR (@HORA_ATUAL >= 18 AND @HORA_ATUAL < 22)
	BEGIN
		RAISERROR ('Entre 12:00 (inclusivo) e 14:00 (N�o inclusivo), e entre 18:00 (inclusivo) e 22:00 (N�o inclusivo), nenhuma modifica��o na tabela TB_VENDAS � permitida',1,1)
		ROLLBACK 
		RETURN 
	END
END
GO

INSERT INTO TB_VENDAS 
VALUES(
	GETDATE(),
	1,
	10,
	12000
)

SELECT * FROM TB_VENDAS