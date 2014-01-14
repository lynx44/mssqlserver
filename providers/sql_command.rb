require 'tempfile'

action :run do
  begin
    timeout = @new_resource.timeout
    args = Hash.new

    if @new_resource.username != nil
      args['-U'] = @new_resource.username
    end

    if @new_resource.password != nil
      args['-P'] = @new_resource.password
    end

    if @new_resource.database != nil
      args['-d'] = @new_resource.database
    end

    if @new_resource.instance != nil
      args['-S'] = @new_resource.instance
    end

    cache_dir = "#{Chef::Config[:file_cache_path]}"

    scriptFile = nil
    if @new_resource.command != nil
      Chef::Log.info("Creating sql script with contents #{@new_resource.command}...")
      scriptFile = script_file
      scriptFile.puts(@new_resource.command)
      Chef::Log.info("Script file created at #{scriptFile.path}");
      args['-i'] = "\"#{scriptFile.path}\""
    else
      args['-i'] = "\"#{@new_resource.script}\""
    end

    cmdargs = args.map{|k,v| "#{k} #{v}"}.join(' ')
    Chef::Log.info("Args #{cmdargs}")

    Chef::Log.info("#{sqlcmd} #{cmdargs}")
    execute "sqlcommand" do
      command "\"#{sqlcmd}\" -b #{cmdargs}"
      returns [0]
      timeout timeout
    end

    if(scriptFile != nil)
      Chef::Log.info("Executed sql script #{scriptFile.path}")
      scriptFile.close
    else
      Chef::Log.info("Executed sql script #{@new_resource.script}")
    end
  end
end

def script_file
  @script_file ||= Tempfile.open(['chef-script', '.sql'])
end

def sqlcmd
  @sqlcmd = node['mssqlserver']['sqlcmdpath']
end