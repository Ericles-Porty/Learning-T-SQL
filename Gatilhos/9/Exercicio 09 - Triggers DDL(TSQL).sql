CREATE TABLE TB_LOG_AUDITORIA (
	id_log int not null primary key identity(1,1),
	dt_log datetime,
	nm_login varchar(30),
	nm_usuario varchar(30),
	banco nvarchar(100),
	esquema nvarchar(100),
	nm_objeto nvarchar(100),
	tipo_objeto nvarchar(100),
	evento nvarchar(100),
	comando nvarchar(2000)
)

GO
CREATE OR ALTER TRIGGER TG_DDL_LOG_AUDITORIA
ON DATABASE
FOR DDL_TABLE_EVENTS, DDL_VIEW_EVENTS, DDL_PROCEDURE_EVENTS
AS
BEGIN
	DECLARE @EVENT XML
	SET @EVENT = EVENTDATA()

	INSERT INTO TB_LOG_AUDITORIA(
	dt_log,
	nm_login,
	nm_usuario,
	banco,
	esquema,
	nm_objeto,
	tipo_objeto,
	evento,
	comando)
	VALUES (
		GETDATE(),
		@EVENT.value('(/EVENT_INSTANCE/LoginName)[1]','nvarchar(30)'),
		@EVENT.value('(/EVENT_INSTANCE/UserName)[1]','nvarchar(30)'),
		@EVENT.value('(/EVENT_INSTANCE/DatabaseName)[1]','nvarchar(100)'),
		@EVENT.value('(/EVENT_INSTANCE/SchemaName)[1]','nvarchar(100)'),
		@EVENT.value('(/EVENT_INSTANCE/ObjectName)[1]','nvarchar(100)'),
		@EVENT.value('(/EVENT_INSTANCE/ObjectType)[1]','nvarchar(100)'),
		@EVENT.value('(/EVENT_INSTANCE/EventType)[1]','nvarchar(100)'),
		@EVENT.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(2000)')
	)

END

CREATE TABLE A (
	id_log int not null primary key identity(1,1),
	dt_log datetime,
	nm_login varchar(30),
	nm_usuario varchar(30),
	banco nvarchar(100),
	esquema nvarchar(100),
	nm_objeto nvarchar(100),
	tipo_objeto nvarchar(100),
	evento nvarchar(100),
	comando nvarchar(2000)
)

SELECT * FROM TB_LOG_AUDITORIA