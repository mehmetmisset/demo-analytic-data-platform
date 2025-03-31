DECLARE @nm_secret NVARCHAR(128) = 'nm_secret',
        @tx_secret NVARCHAR(999) = 'tx_secret';

DELETE FROM dbo.secrets WHERE nm_secret = @nm_secret;
INSERT INTO dbo.secrets (nm_secret, tx_secret) VALUES (@nm_secret, @tx_secret);
GO