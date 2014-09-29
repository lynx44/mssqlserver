action :run do
  source_kill_command = MsSqlServer::RenameScripts.create_kill_script(node['source_name'])

  mssqlserver_sql_command "kill connections to #{node['source_name']}" do
    command source_kill_command
    database 'master'
    action :run
  end

  dest_kill_command = MsSqlServer::RenameScripts.create_kill_script(node['dest_name'])

  mssqlserver_sql_command "kill connections to #{node['dest_name']}" do
    command dest_kill_command
    database 'master'
    action :run
  end

  destination_temp_name = "#{node['dest_name']}_Renamed"
  destination_temp_rename_command = MsSqlServer::RenameScripts.create_rename_script(node['dest_name'], destination_temp_name)

  mssqlserver_sql_command "rename #{node['dest_name']} to #{destination_temp_name}" do
    command destination_temp_rename_command
    database 'master'
    action :run
  end

  source_rename_command = MsSqlServer::RenameScripts.create_rename_script(node['source_name'], node['dest_name'])

  mssqlserver_sql_command "rename #{node['source_name']} to #{node['dest_name']}" do
    command source_rename_command
    database 'master'
    action :run
  end

  dest_rename_command = MsSqlServer::RenameScripts.create_rename_script(destination_temp_name, node['source_name'])

  mssqlserver_sql_command "rename #{destination_temp_name} to #{node['source_name']}" do
    command dest_rename_command
    database 'master'
    action :run
  end
end