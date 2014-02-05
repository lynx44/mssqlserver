action :run do
  mssqlserver_sql_command @new_resource.name do
    database 'master'
    command build_command
  end
end

def build_command
  @command ||= "BACKUP LOG [#{@new_resource.database}] TO  DISK = N'#{@new_resource.destination}' WITH #{with_options}
    GO"
end

def with_options
  options = @new_resource.with || ['NOFORMAT', 'NOINIT', 'NOSKIP', 'REWIND', 'NOUNLOAD', 'COMPRESSION', 'STATS = 5']
  options.join(', ')
end