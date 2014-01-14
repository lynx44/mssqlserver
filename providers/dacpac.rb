action :run do
	begin
		args = Hash.new
		
		if @new_resource.server != nil
		  args['/TargetServerName'] = @new_resource.server
    end

		if @new_resource.username != nil
		  args['/TargetUser'] = @new_resource.username
		end
		
		if @new_resource.password != nil
		  args['/TargetPassword'] = @new_resource.password
		end
		
		if @new_resource.database != nil
		  args['/TargetDatabaseName'] = @new_resource.database
		end
		
		if @new_resource.dacpacpath != nil
		  args['/SourceFile'] = @new_resource.dacpacpath
		end
		
		if @new_resource.sqlaction != nil
		  args['/Action'] = @new_resource.sqlaction
		end
		
		if @new_resource.variables != nil
		  args['/Variables'] = @new_resource.variables.map{|k,v| "#{k}=#{v}"}.join(';')
		end
		
=begin		
		if @new_resource.instance != nil
		  args['-S'] = @new_resource.instance
		end
=end
		
		cmdargs = args.map{|k,v| "#{k}:\"#{v}\""}.join(' ')
		Chef::Log.info("Args #{cmdargs}")
		
		Chef::Log.info("#{sqlpackage} #{cmdargs}")
		windows_batch "dacpac command" do
		  code "\"#{sqlpackage}\" #{cmdargs}"
		end
	end
end

def sqlpackage
   @sqlpackage = node['msssqlserver']['dacpath']['sqlpackagepath']
end