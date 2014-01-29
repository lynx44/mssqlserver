action :run do
  mssqlserver_sql_command 'run backup script' do
    database 'master'
    command build_command
  end
end

def build_command
  @command ||= "BACKUP DATABASE [#{@new_resource.database}] TO  DISK = N'#{@new_resource.destination}' WITH NOFORMAT, INIT,  NAME = N'#{@new_resource.database}-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
    GO"
end