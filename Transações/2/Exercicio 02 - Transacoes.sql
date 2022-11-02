-- Tabelas de Contas.
CREATE TABLE TB_CONTA (
   NR_AGENCIA INT NOT NULL,
   NR_CONTA INT NOT NULL,
   CPF INT NOT NULL,
   SALDO NUMERIC(10,2),
   PRIMARY KEY (NR_AGENCIA, NR_CONTA)
)

-- Tabela de Lancamentos
/*  TIPO: C - CREDITO
          D - DEBITO

    STATUS: P - PENDENTE. Todos os Lancamentos possuem inicialmente esse status.
            E - EFETUADO. Todos os Lancamentos que já foram efetuados.
            N - NAO EFETUADO. Todos os Lancamentos que não foram efetuados por alguma restricao
                              de negocio. Exemplo: Saldo Insuficiente para Debito.
                              
    MENSAGEM: Mensagem de texto informando a restricao que fez com que o lancamento não fosse 
              efetuado. Exemplo: 'SALDO INSUFICIENTE'
*/

CREATE TABLE TB_LANCAMENTO (
   ID_LANCAMENTO INT NOT NULL IDENTITY(1,1),
   DT_LANCAMENTO DATETIME NOT NULL,
   NR_AGENCIA INT NOT NULL,
   NR_CONTA INT NOT NULL,
   TIPO CHAR(1) CHECK (TIPO IN ('C', 'D')),
   VALOR NUMERIC (10,2),
   STATUS CHAR(1) NULL CHECK (STATUS IN ('P','E','N')),
   MENSAGEM VARCHAR (200) NULL
)

ALTER TABLE TB_LANCAMENTO ADD CONSTRAINT FK_AGENCIA_CONTA
FOREIGN KEY (NR_AGENCIA, NR_CONTA) 
REFERENCES TB_CONTA (NR_AGENCIA, NR_CONTA)

ALTER TABLE TB_LANCAMENTO
ADD CONSTRAINT DF_STATUS DEFAULT ('P') FOR STATUS






