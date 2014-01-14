#this is a minefield to run remotely through winrm
#first you must enable credSSP on the client and server (including WSMAN/* settings on the client)
#then, you must use the -ad credentials to call over winrs

include_recipe 'windows::reboot_handler'
#include_recipe 'dotnetframework' #installer will bork without .net 4.0 when running over winrm

config_file_path = win_friendly_path(File.join(Chef::Config[:file_cache_path], "ConfigurationFile.ini"))

windows_feature "NetFx3" do
	action :install
end

template config_file_path do
  source "ConfigurationFile.ini.erb"
end

source = node['mssqlserver']['server']['url']
checksum = node['mssqlserver']['server']['checksum']

Chef::Log.debug("Sql server package URL is #{source}")
Chef::Log.debug("Sql server package checksum is #{checksum}")

if source.end_with?('.zip')
	tempPath = win_friendly_path(File.join(Chef::Config[:file_cache_path], "sqlserver"))
  setupPath = File.join(tempPath, "setup.exe")
	windows_zipfile tempPath do
		source source
		checksum node['mssqlserver']['server']['checksum']
		action :unzip
		not_if do
			::File.exist?(setupPath)
		end
	end
	source = setupPath
	checksum = nil
end

windows_package node['mssqlserver']['server']['package_name'] do
  source source
  checksum checksum
  installer_type :custom
  timeout 9000
  options "/ConfigurationFile=#{config_file_path}"
  action :install
end

mssqlserver_sqlcommand "add builtin/administrators" do
  command <<-EOH
    IF NOT EXISTS(SELECT * FROM syslogins WHERE [name] = 'BUILTIN\\Administrators')
    BEGIN
      CREATE LOGIN [BUILTIN\\Administrators] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
    END
    GO

    IF IS_ROLEMEMBER('sysadmin', 'BUILTIN\\Administrators') IS NULL OR IS_ROLEMEMBER('sysadmin', 'BUILTIN\\Administrators') = 0
    BEGIN
      ALTER SERVER ROLE [sysadmin] ADD MEMBER [BUILTIN\\Administrators]
    END
    GO
  EOH
  username 'sa'
  password node['mssqlserver']['server']['sa_password']
  database 'master'
  instance 'localhost'
  action :run
end

include_recipe "mssqlserver::firewall"