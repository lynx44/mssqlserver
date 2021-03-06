actions = [:run]
actions.insert(0, :drop) if node['mssqlserver']['restore']['drop']
mssqlserver_restore_database 'restore sql database' do
  file_path  node['mssqlserver']['restore']['filepath']
  #server    node['mssqlserver']['restore']['server']
  username  node['mssqlserver']['restore']['username']
  password  node['mssqlserver']['restore']['password']
  database  node['mssqlserver']['restore']['database']
  instance  node['mssqlserver']['restore']['instance']
  with      node['mssqlserver']['restore']['with']
  data_directory node['mssqlserver']['restore']['data_directory']
  log_directory node['mssqlserver']['restore']['log_directory']
  action actions
end