mssqlserver_restoredatabase "restore sql database" do
  filepath  node['mssqlserver']['restore']['filepath']
  server    node['mssqlserver']['restore']['server']
  username  node['mssqlserver']['restore']['username']
  password  node['mssqlserver']['restore']['password']
  database  node['mssqlserver']['restore']['database']
  instance  node['mssqlserver']['restore']['instance']
  with      node['mssqlserver']['restore']['with']
  data_directory node['mssqlserver']['restore']['data_directory']
end