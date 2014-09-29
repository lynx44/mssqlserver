module MsSqlServer
  module RenameScripts
    def self.create_kill_script(db_name)
      "DECLARE @KillCurrentConnectionsCommand NVARCHAR(MAX)
SET @KillCurrentConnectionsCommand = N''

SELECT @KillCurrentConnectionsCommand = @KillCurrentConnectionsCommand + N'Kill ' + Convert(varchar, SPId) + N';'
FROM MASTER..SysProcesses
WHERE DBId = DB_ID('#{db_name}') AND SPId <> @@SPId
EXEC(@KillCurrentConnectionsCommand)"
    end

    def self.create_rename_script(source_name, dest_name)
      "ALTER DATABASE #{source_name}
Modify Name = #{dest_name};"
    end
  end
end