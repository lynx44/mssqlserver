require 'tempfile'
include Windows::Helper

action :run do
  begin
    timeout = @new_resource.timeout
    cache_dir = "#{Chef::Config[:file_cache_path]}"

    scriptFile = nil
    script_path = @new_resource.script
    if @new_resource.command != nil
      Chef::Log.info("Creating sql script with contents #{@new_resource.command}...")
      scriptFile = script_file
      scriptFile.puts(@new_resource.command)
      Chef::Log.info("Script file created at #{scriptFile.path}");
      script_path = scriptFile.path
    end

    shell_command = helper.create_shell_command(script_path)

    execute "sqlcommand" do
      command shell_command
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

action :bat do
  shell_command = helper.create_shell_command(@new_resource.script)
  path = @new_resource.batch_path
  file win_friendly_path(path) do
    content shell_command
  end
end

def script_file
  @script_file ||= Tempfile.open(['chef-script', '.sql'])
end

def helper
  helper ||= MSSqlServerCookbook::SqlCmdHelper.new(@new_resource, node)
end