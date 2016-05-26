action :run do
	begin
		args = Hash.new
		
		if @new_resource.server != nil
		  args['/TargetServerName'] = quote(@new_resource.server)
    end

		if @new_resource.username != nil
		  args['/TargetUser'] = quote(@new_resource.username)
		end
		
		if @new_resource.password != nil
		  args['/TargetPassword'] = quote(@new_resource.password)
		end
		
		if @new_resource.database != nil
		  args['/TargetDatabaseName'] = quote(@new_resource.database)
		end
		
		if @new_resource.dacpac_path != nil
		  args['/SourceFile'] = quote(@new_resource.dacpac_path)
		end
		
		if @new_resource.sql_action != nil
		  args['/Action'] = quote(@new_resource.sql_action)
		end

		if @new_resource.variables != nil
      args['/Variables'] = @new_resource.variables.map{|k,v| quote("#{k}=#{v}")}.join(' /Variables:')
		end
		
		cmdargs = args.map{|k,v| "#{k}:#{v}"}.join(' ')
		Chef::Log.info("Args #{cmdargs}")
		
		Chef::Log.info("#{sqlpackage} #{cmdargs}")
		batch 'dacpac command' do
		  code "\"#{sqlpackage}\" #{cmdargs}"
		end
	end
end

def sqlpackage
   @sqlpackage = node['msssqlserver']['dacpath']['sqlpackagepath']
end

def quote(val)
  "\"#{val}\""
end