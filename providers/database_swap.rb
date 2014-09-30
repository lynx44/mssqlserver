action :run do
  source = @new_resource.source
  destination = @new_resource.destination
  source_kill_command = MsSqlServer::RenameScripts.create_kill_script(source)

  mssqlserver_sql_command "kill connections to #{source}" do
    command source_kill_command
    database 'master'
    action :run
  end

  dest_kill_command = MsSqlServer::RenameScripts.create_kill_script(destination)

  mssqlserver_sql_command "kill connections to #{destination}" do
    command dest_kill_command
    database 'master'
    action :run
  end

  destination_temp_name = "#{destination}_Renamed"
  destination_temp_rename_command = MsSqlServer::RenameScripts.create_rename_script(destination, destination_temp_name)

  mssqlserver_sql_command "rename #{destination} to #{destination_temp_name}" do
    command destination_temp_rename_command
    database 'master'
    action :run
  end

  source_rename_command = MsSqlServer::RenameScripts.create_rename_script(source, destination)

  mssqlserver_sql_command "rename #{source} to #{destination}" do
    command source_rename_command
    database 'master'
    action :run
  end

  dest_rename_command = MsSqlServer::RenameScripts.create_rename_script(destination_temp_name, source)

  mssqlserver_sql_command "rename #{destination_temp_name} to #{source}" do
    command dest_rename_command
    database 'master'
    action :run
  end
end