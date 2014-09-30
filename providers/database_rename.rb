action :run do
  kill_connections(source)
  rename(source, destination)
end

action :swap do
  kill_connections(source)
  kill_connections(destination)

  destination_temp_name = "#{destination}_Renamed"
  rename(destination, destination_temp_name)
  rename(source, destination)
  rename(destination_temp_name, source)
end

def kill_connections(db_name)
  kill_command = MsSqlServer::RenameScripts.create_kill_script(db_name)

  mssqlserver_sql_command "kill connections to #{db_name}" do
    command kill_command
    database 'master'
    action :run
  end
end

def rename(source_name, dest_name)
  source_rename_command = MsSqlServer::RenameScripts.create_rename_script(source_name, dest_name)

  mssqlserver_sql_command "rename #{source_name} to #{dest_name}" do
    command source_rename_command
    database 'master'
    action :run
  end
end

def source
  @new_resource.source
end

def destination
  @new_resource.destination
end