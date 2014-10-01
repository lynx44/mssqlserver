action :create do
  database = @new_resource.database
  sql_command = "IF NOT EXISTS(SELECT Name FROM sys.databases WHERE Name='#{database}') BEGIN CREATE DATABASE [#{database}] END"
  username = @new_resource.username
  password = @new_resource.password
  instance = @new_resource.instance
  mssqlserver_sql_command "create #{database} database" do
    username username
    password password
    database 'master'
    instance instance
    command sql_command
  end
end

action :drop do
  database = @new_resource.database
  sql_command = "IF EXISTS(SELECT Name FROM sys.databases WHERE Name='#{database}') BEGIN DROP DATABASE [#{database}] END"
  username = @new_resource.username
  password = @new_resource.password
  instance = @new_resource.instance
  mssqlserver_sql_command "drop #{database} database" do
    username username
    password password
    database 'master'
    instance instance
    command sql_command
  end
end