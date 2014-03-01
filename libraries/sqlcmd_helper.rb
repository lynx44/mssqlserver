module MSSqlServerCookbook
  class SqlCmdHelper
    def initialize(resource, node)
      @new_resource = resource
      @node = node
    end

    def create_shell_command(script_path)
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

      args['-i'] = "\"#{script_path}\""

      cmdargs = args.map{|k,v| "#{k} #{v}"}.join(' ')
      Chef::Log.info("Args #{cmdargs}")

      shell_command = "\"#{sqlcmd}\" -b #{cmdargs}"
      Chef::Log.info(shell_command)

      shell_command
    end

    def sqlcmd
      @sqlcmd = @node['mssqlserver']['sqlcmdpath']
    end
  end
end