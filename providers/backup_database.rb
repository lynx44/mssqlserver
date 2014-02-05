action :run do
  mssqlserver_sql_command 'run backup script' do
    database 'master'
    command build_command
  end
end

def build_command
  @command ||= "BACKUP DATABASE [#{@new_resource.database}] TO  DISK = N'#{@new_resource.destination}' WITH #{with_options}
    GO"
end

def with_options
  options = @new_resource.with || ['NOFORMAT', 'INIT', 'SKIP', 'NOREWIND', 'NOUNLOAD', 'STATS = 10']
  options = ["NAME = N'#{@new_resource.database}-Full Database Backup'"].concat(options)
  options.join(', ')
end