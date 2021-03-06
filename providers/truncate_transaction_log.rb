action :run do
	begin
		database = @new_resource.database
		instance = @new_resource.instance
		mssqlserver_sql_command 'truncate transaction log' do
			command <<-EOH
				IF (EXISTS (SELECT name 
				FROM master.dbo.sysdatabases 
				WHERE (name = '#{database}')))
				BEGIN
					DECLARE @DatabaseName NVARCHAR(MAX)
					SET @DatabaseName = '#{database}'

					DECLARE @LogName NVARCHAR(MAX);

					SELECT 
					@LogName = sys.master_files.name
					FROM sys.databases
					INNER JOIN sys.master_files
					ON sys.databases.database_id=sys.master_files.database_id
					WHERE sys.databases.name=@DatabaseName AND type_desc='LOG'

					EXEC(
					 'USE [' + @DatabaseName + ']
          DBCC SHRINKFILE (N''' + @LogName + ''', 0, TRUNCATEONLY)')
				END
			EOH
			instance instance
			action :run
		end
	end
end