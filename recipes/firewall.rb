windows_firewall_rule "SQL Server" do
  localport "1433"
  only_if { node['mssqlserver']['server']['open_firewall_port'] }
end