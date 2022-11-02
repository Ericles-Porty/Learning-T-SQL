/* Exercício 11 - Procedimentos Armazenados */

CREATE TABLE TB_USUARIO (
  CD_USUARIO INT NOT NULL PRIMARY KEY,
  NM_USUARIO VARCHAR(60) NOT NULL,
  CPF INT NULL
)

INSERT INTO TB_USUARIO (CD_USUARIO, NM_USUARIO, CPF)
VALUES (1, 'JOAO', 51673)

INSERT INTO TB_USUARIO (CD_USUARIO, NM_USUARIO, CPF)
VALUES (2, 'CARLOS', 43444)

INSERT INTO TB_USUARIO (CD_USUARIO, NM_USUARIO, CPF)
VALUES (3, 'ROBERTO', 98337)

SELECT * FROM TB_USUARIO

CREATE TABLE TB_LANCAMENTOS (
   CD_LANCAMENTO INT NOT NULL PRIMARY KEY IDENTITY(1,1),
   MES INT NOT NULL,
   ANO INT NOT NULL,
   CD_USUARIO INT NOT NULL,
   TP_LANCAMENTO VARCHAR(1) CHECK (TP_LANCAMENTO IN ('R', 'D')),
   DESCRICAO VARCHAR(200) NOT NULL,
   VALOR NUMERIC(10,2) NOT NULL
)

INSERT INTO TB_LANCAMENTOS (MES, ANO, CD_USUARIO, TP_LANCAMENTO, DESCRICAO, VALOR)
VALUES (1, 2019, 1, 'R', 'CURSO', 100.00),
       (1, 2019, 1, 'R', 'PALESTRA', 300.00),
       (1, 2019, 1, 'D', 'COMBUSTÍVEL', 200.00),
       (4, 2019, 1, 'R', 'CURSO', 400.00),
       (1, 2019, 2, 'R', 'SEMINÁRIO', 200.00),
       (1, 2019, 2, 'R', 'PALESTRA', 100.00),
       (1, 2019, 2, 'D', 'DIÁRIA', 500.00)
    
CREATE TABLE TB_RESUMO_FINANCEIRO (
   CD_USUARIO INT NOT NULL,
   MES INT NOT NULL,
   ANO INT NOT NULL,
   TOTAL_RECEITAS NUMERIC(10,2) NOT NULL,
   TOTAL_DESPESAS NUMERIC(10,2) NOT NULL,
   PRIMARY KEY(CD_USUARIO, MES, ANO)
)

1. Criar um procedimento armazenado SP_OBTEM_RESUMO para obter valores totais de receita e
   despesa para um determinado funcionário, em um Mês e Ano. O procedimento deve receber como
   parâmetros de entrada o Código do Usuário, o Mês e Ano, e deve retornar como parâmetros de
   saída o Total de Receitas e o Total de Despesas calculados a partir da Tabela
   TB_LANCAMENTOS. Na tabela TB_LANCAMENTOS, as receitas são identificadas com R e as
   despesas com D no campo TP_LANCAMENTO.
 
CREATE PROCEDURE SP_OBTEM_RESUMO (@CD_USUARIO INT, @MES INT, @ANO INT, 
                                  @TOTAL_RECEITAS NUMERIC(10,2) OUTPUT,
                                  @TOTAL_DESPESAS NUMERIC(10,2) OUTPUT)
AS
BEGIN
   SET @TOTAL_RECEITAS = (SELECT ISNULL(SUM(VALOR),0)
						  FROM TB_LANCAMENTOS
						  WHERE MES = @MES AND
						        ANO = @ANO AND
						        CD_USUARIO = @CD_USUARIO AND
						        TP_LANCAMENTO = 'R')
   						  
   SET @TOTAL_DESPESAS = (SELECT ISNULL(SUM(VALOR),0)
						  FROM TB_LANCAMENTOS
						  WHERE MES = @MES AND
						        ANO = @ANO AND
						        CD_USUARIO = @CD_USUARIO AND
						        TP_LANCAMENTO = 'D')     
END                                   


---------------------

Versão Compacta

CREATE OR ALTER PROCEDURE SP_OBTEM_RESUMO (@CD_USUARIO INT, @MES INT, @ANO INT, 
                                           @TOTAL_RECEITAS NUMERIC(10,2) OUTPUT,
                                           @TOTAL_DESPESAS NUMERIC(10,2) OUTPUT)
AS 
 BEGIN
   SELECT @TOTAL_RECEITAS = ISNULL(SUM (CASE WHEN TP_LANCAMENTO = 'R' THEN VALOR ELSE 0 END),0),
          @TOTAL_DESPESAS = ISNULL(SUM (CASE WHEN TP_LANCAMENTO = 'D' THEN VALOR ELSE 0 END),0)      
   FROM TB_LANCAMENTOS
   WHERE MES = @MES AND
         ANO = @ANO AND
         CD_USUARIO = @CD_USUARIO
 END   
 

 

2. Criar um procedimento armazenado SP_INCLUI_RESUMO_FINANCEIRO para incluir um
   resumo financeiro para um determinado Ano para todos os usuários da tabela TB_USUARIO. O
   procedimento deve receber como parâmetro de entrada o Ano, e incluir uma linha de resumo para
   todos os meses do ano para cada usuário da tabela TB_USUARIO. O procedimento deve, para
   cada usuário da tabela TB_USUARIO, calcular o Total de Despesas e o Total de Receitas por Mês
   e Ano utilizando o procedimento criado na questão 1. Todos os meses do ano devem ser incluídos
   no Resumo para todos os usuários, mesmo aqueles meses que não apresentem despesas e receitas.
   
CREATE PROCEDURE SP_INCLUI_RESUMO_FINANCEIRO (@ANO INT)
AS
BEGIN
  DECLARE @CD_USUARIO INT,
          @MES INT,
          @TOTAL_RECEITAS NUMERIC(10,2),
          @TOTAL_DESPESAS NUMERIC(10,2)

  DECLARE C_USUARIO CURSOR FOR SELECT CD_USUARIO FROM TB_USUARIO
  
  OPEN C_USUARIO
  FETCH C_USUARIO INTO @CD_USUARIO
  WHILE (@@FETCH_STATUS = 0 )
    BEGIN
      SET @MES = 1
      WHILE @MES <= 12 
        BEGIN
           EXEC SP_OBTEM_RESUMO @CD_USUARIO, @MES, @ANO, @TOTAL_RECEITAS OUTPUT,
                                @TOTAL_DESPESAS OUTPUT
           INSERT INTO TB_RESUMO_FINANCEIRO (CD_USUARIO, MES, ANO, TOTAL_RECEITAS, 
                                             TOTAL_DESPESAS)
           VALUES(@CD_USUARIO, @MES, @ANO, @TOTAL_RECEITAS, @TOTAL_DESPESAS)
           SET @MES = @MES + 1                                                                 
        END 
      FETCH C_USUARIO INTO @CD_USUARIO
    END          
  CLOSE C_USUARIO
  DEALLOCATE C_USUARIO
END   


-- TESTE

SELECT * FROM TB_LANCAMENTOS
SELECT * FROM TB_RESUMO_FINANCEIRO

EXEC SP_INCLUI_RESUMO_FINANCEIRO 2019









	


