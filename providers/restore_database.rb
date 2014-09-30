require 'pathname'
include Windows::Helper

action :run do
  sql_command = create_script_contents
	Chef::Log.debug("#{sql_command}")
	mssqlserver_sql_command 'restoredatabase' do
		command sql_command
		instance instance
    timeout timeout
		action :run
	end
end

action :drop do
  database = @new_resource.database
  instance = @new_resource.instance
  mssqlserver_sql_command "drop database #{database}" do
    command "IF EXISTS(SELECT name FROM sys.databases WHERE name='#{database}')
BEGIN
	DROP DATABASE [#{database}]
END"
    instance instance
    database 'master'
    action :run
  end
end

action :script do
  script_path = @new_resource.script_path
  command = create_script_contents
  file script_path do
    content create_script_contents
  end
end

def create_script_contents
  filepath = unzip(@new_resource.file_path)
  filepath = win_friendly_path(filepath)
  database = @new_resource.database
  data_directory = @new_resource.data_directory
  log_directory = @new_resource.log_directory
  ignore_logs = @new_resource.ignore_logs
  instance = @new_resource.instance
  timeout = @new_resource.timeout
  withOptions = @new_resource.with == nil ? "RECOVERY" : @new_resource.with.join(",")
  Chef::Log.info("Restoring database #{database} from #{filepath}")
  command = <<-EOH
		USE MASTER

		DECLARE @Path AS NVARCHAR(MAX);
		SET @Path = N'#{filepath}';

		DECLARE @DatabaseName AS NVARCHAR(MAX);
		SET @DatabaseName = N'#{database}';

		DECLARE @DataDirectory AS NVARCHAR(MAX)
		SET @DataDirectory = '#{data_directory}'

    DECLARE @LogDirectory AS NVARCHAR(MAX)
		SET @LogDirectory = '#{log_directory}'

		DECLARE @LogicalDataName AS NVARCHAR(MAX)
		DECLARE @LogicalLogName AS NVARCHAR(MAX)

		/* get the file list from the current backup */
		IF OBJECT_ID('tempdb..#filelist') IS NOT NULL
			DROP TABLE #filelist

		CREATE TABLE #filelist(
		LogicalName NVARCHAR(MAX),
		PhysicalName NVARCHAR(MAX),
		[Type] NVARCHAR(1),
		FileGroupName NVARCHAR(MAX),
		Size NVARCHAR(MAX),
		MaxSize BIGINT,
		FileId INT,
		CreateLSN BIT,
		DropLSN BIT,
		UniqueId UNIQUEIDENTIFIER,
		ReadOnlyLSN BIT,
		ReadWriteLSN BIT,
		BackupSizeInBytes BIGINT,
		SourceBlockSize INT,
		FileGroupId INT,
		LogGroupGUID UNIQUEIDENTIFIER,
		DifferentialBaseLSN FLOAT,
		DifferentialBaseGUID UNIQUEIDENTIFIER,
		IsReadOnly BIT,
		IsPresent BIT,
		TDEThumbprint NVARCHAR(MAX))

		INSERT #filelist
		EXECUTE sp_executesql N'RESTORE FILELISTONLY
		FROM DISK=@Path', N'@Path NVARCHAR(MAX)', @Path=@Path

		SELECT * FROM #filelist;

		/* end get the file list from the current backup */

		/* get the file list from the live database */

		--if a specific directory was specified, set the log paths to move to that directory
		IF(@DataDirectory != '')
		BEGIN
      --map all files (including logs) to the data directory if specified
			UPDATE #filelist SET PhysicalName = @DataDirectory + '\\' + (CASE WHEN Type='D' THEN @DatabaseName + (CASE WHEN CreateLSN > 0 THEN CONVERT(VARCHAR, CreateLSN + 1) ELSE '' END) + '.MDF' ELSE @DatabaseName + (CASE WHEN CreateLSN > 0 THEN CONVERT(VARCHAR, CreateLSN + 1) ELSE '' END) + '_Log.LDF' END)
		END

    IF(@LogDirectory != '')
		BEGIN
      --map the log files to the specified directory
			UPDATE #filelist SET PhysicalName = @LogDirectory + SUBSTRING(PhysicalName, LEN(PhysicalName) - CHARINDEX('\\', REVERSE(PhysicalName)) + 1, CHARINDEX('\\', REVERSE(PhysicalName)) + 1)
      WHERE [Type]='L'
		END

		SELECT * FROM #filelist

		/* end get the file list from the live database */

		/* kill any connections to the current database */

		DECLARE @KillCurrentConnectionsCommand NVARCHAR(MAX)
		SET @KillCurrentConnectionsCommand = N''

		SELECT @KillCurrentConnectionsCommand = @KillCurrentConnectionsCommand + N'Kill ' + Convert(varchar, SPId) + N';'
		FROM MASTER..SysProcesses
		WHERE DBId = DB_ID(@DatabaseName) AND SPId <> @@SPId
		EXEC(@KillCurrentConnectionsCommand)

		/* end kill any connections to the current database */

		DECLARE @RestoreDatabaseCommand NVARCHAR(MAX);
		DECLARE @RestoreDatabaseParams NVARCHAR(MAX);
		SET @RestoreDatabaseParams = N'@Path NVARCHAR(MAX)';

		SET @RestoreDatabaseCommand = N'RESTORE DATABASE ' + @DatabaseName + N' FROM DISK=@Path ';

		BEGIN
			SET @RestoreDatabaseParams = @RestoreDatabaseParams +
			N', @LogicalDataName NVARCHAR(MAX), @LogicalLogName NVARCHAR(MAX)';

			DECLARE @MoveStatement AS NVARCHAR(MAX)
			SET @MoveStatement = ''

			SELECT @MoveStatement = @MoveStatement + 'MOVE ''' + LogicalName + ''' TO ''' + PhysicalName + ''','
			FROM #filelist

			SELECT @MoveStatement MoveStatement

			SET @RestoreDatabaseCommand = @RestoreDatabaseCommand +
			N'WITH #{withOptions}, ' +
			@MoveStatement +
			' REPLACE';
		END

		SELECT @RestoreDatabaseCommand;

		EXECUTE sp_executesql
		@RestoreDatabaseCommand,
		@RestoreDatabaseParams,
		@Path=@Path,
		@LogicalDataName=@LogicalDataName,
		@LogicalLogName=@LogicalLogName
  EOH
end

private
def unzip(filepath)
	cache_dir = "#{Chef::Config[:file_cache_path]}/database"
	archivepath = "#{cache_dir}/#{Pathname.new(filepath).basename}"
	
	directory cache_dir do
		action :create
	end
	
	backuppath = filepath
  if(::File.exist?(archivepath) && ::File.size(archivepath) == 0)
    ::File.delete(archivepath)
  end

	if filepath.start_with?("http")
		remote_file archivepath do
		  source filepath
		  not_if {::File.exist?(archivepath)}
		end
	end
	
	if(archivepath.end_with?(".zip"))
		backupname = "#{Pathname.new(filepath).basename}".gsub('zip', 'bak')
		backuppath = "#{cache_dir}/#{backupname}"
		mssqlserver_unzip_database "unzip database" do
			archive_path archivepath
			backup_path backuppath
			action :unzip
		end
	end
	
	return backuppath
end