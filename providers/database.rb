action :create do
  sql_command = "IF NOT EXISTS(SELECT Name FROM sys.databases WHERE Name='#{node['database']}') BEGIN CREATE DATABASE [#{node['database']}] END"
  mssqlserver_sql_command "create #{node['database']} database" do
    username node['username']
    password node['password']
    database 'master'
    instance node['instance']
    command sql_command
  end
end