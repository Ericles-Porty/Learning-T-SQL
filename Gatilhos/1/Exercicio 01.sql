CREATE TABLE TB_ALUNO (
    MATRICULA INT NOT NULL PRIMARY KEY,
    NOME VARCHAR(50) NOT NULL,
    RG INT NULL,
    ENDERECO VARCHAR(100) NULL,
    TELEFONE VARCHAR (20) NULL,
)

CREATE TABLE TB_LOG_PENDENCIAS (
  MATRICULA INT,
  NOME VARCHAR(50),
  PENDENCIA VARCHAR(200)
)


