CREATE DATABASE Musterbank;
GO
USE Musterbank;
-- Einfache Konto-Tabelle erstellen
CREATE TABLE Account (
	AccountID INT IDENTITY(1,1) NOT NULL,
	CustomerName NVARCHAR(200) NOT NULL,
	Currency NCHAR(20) NOT NULL DEFAULT 'CHF',
	AccountBalance MONEY NOT NULL DEFAULT 0,
    PRIMARY KEY (AccountID)
);
GO


INSERT INTO Account (CustomerName, AccountBalance) VALUES 
('Max Mustermann', 1200), 
('Jane Doe', 1500);
GO


UPDATE Account SET AccountBalance = AccountBalance - 500 WHERE AccountID = 1;
UPDATE Account SET AccountBalance = AccountBalance + 500 WHERE AccountID = 2;

BEGIN TRANSACTION;
UPDATE Account SET AccountBalance = AccountBalance - 500 WHERE AccountID = 1;
UPDATE Account SET AccountBalance = AccountBalance + 500 WHERE AccountID = 2;
COMMIT TRANSACTION;


--rollback
BEGIN TRANSACTION;
UPDATE Account SET AccountBalance = AccountBalance - 500 WHERE AccountID = 1;
UPDATE Account SET AccountBalance = AccountBalance + 500 WHERE AccountID = 2;
ROLLBACK TRANSACTION;

ALTER TABLE Account 
ADD CONSTRAINT CHK_Kontoueberziehung CHECK (AccountBalance >= 0);

BEGIN TRANSACTION

BEGIN TRY
    -- Überweise CHF 500.- von Konto 1 auf Konto 2:
    UPDATE Account SET AccountBalance = AccountBalance - 500 WHERE AccountID = 1
    UPDATE Account SET AccountBalance = AccountBalance + 500 WHERE AccountID = 2

    -- Commit der Transaktion
    COMMIT TRANSACTION

    -- Erfolgsmeldung ausgeben
    SELECT 'COMMITED: Transaktion von CHF 500 war erfolgreich!' AS Meldung
END TRY

BEGIN CATCH
    -- Dieser Codeblock wird ausgeführt, sollte eine der Anweisungen fehlerhaft sein.
    -- Rollback der Transaktion
    ROLLBACK TRANSACTION
    
    -- Fehlermeldung ausgeben
    SELECT 'ROLLBACK: Zu wenig Geld auf dem Konto!' AS Meldung
END CATCH

GO