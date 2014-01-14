mssqlserver Cookbook
====================
This cookbook provides some common functionality for Sql Server. This is currently a very early release, everything is a work in progress.

Requirements
------------
windows
powershell
dotnetframework
windows_firewall

Recipes
----------
#### mssqlserver::firewall

Opens the default firewall port.

#### mssqlserver::restore_database

Restores a database.

    # uri (url or local file path) to backup file. Can be a .bak. bkf, or .zip file.
    default['mssqlserver']['restore']['filepath'] = 'c:\backup.bak'

    # folder where database should reside
    default['mssqlserver']['restore']['data_directory'] = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA'

    # database name
    default['mssqlserver']['restore']['database']

    # username with permissions to restore a database
    default['mssqlserver']['restore']['username']

    # password for the above user
    default['mssqlserver']['restore']['password']

    # instance. by default this is localhost. for sqlexpress, you may want to use localhost\SQLEXPRESS
    default['mssqlserver']['restore']['instance']

    # array of WITH options for restore. options are typically 'recovery' or 'norecovery'
    default['mssqlserver']['restore']['with']

#### mssqlserver::server

Configures Sql Server 2012.

This recipe will only work under the following conditions:

- .NET Framework 4.0 is installed on the machine

- If chef-client is run remotely, it must be run using winrs with the -ad option.
- \[remote machine\] winrm set winrm/config/client/auth @{CredSSP="true"}
- \[client machine\] winrm set winrm/config/client/auth @{CredSSP="true"}
- \[client machine\] Enable AllowFreshCredentials:
- Local Computer Policy -> Computer Configuration -> Administrative Templates -> System -> Credentials Delegation
- Enable each of the "Allow Delegating [...] Credentials" permissions. For each, click on "Show" and add WSMAN/*.your.domain.com (or WSMAN/* for any servers)

- Example remote command:
   + winrs -r:http://myserver:5985 -ad -u:Administrator chef-client -o "recipe[mssqlserver::server]"
