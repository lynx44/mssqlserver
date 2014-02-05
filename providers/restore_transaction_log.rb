action :run do
  mssqlserver_sql_command @new_resource.name do
    database 'master'
    command build_command
  end
end

def build_command
  @command ||= "RESTORE LOG [#{@new_resource.database}] FROM  DISK = N'#{@new_resource.source}' WITH #{with_options}
    GO"
end

def with_options
  options = @new_resource.with || ['NOUNLOAD', 'STATS = 5']
  options.join(', ')
end