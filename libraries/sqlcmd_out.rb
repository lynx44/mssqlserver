require 'tempfile'

class Chef
  module Mixin
    module SqlCmdOut
      include Chef::Mixin::ShellOut

      #command
      #server
      #username
      #password
      #database
      #instance

      def sqlcmd_out(script, args)
        run_command(script, parse_args(args))
      end

      def sqlcmd_out!(script, args)
        cmd = sqlcmd_out(script, args)
        cmd.error!
        cmd
      end

      private
      def parse_args(cmdArgs)
        args = Hash.new

        if @new_resource.server != nil
          args['-S'] = cmdArgs.server
        end

        if @new_resource.username != nil
          args['-U'] = cmdArgs.username
        end

        if @new_resource.password != nil
          args['-P'] = cmdArgs.password
        end

        if @new_resource.database != nil
          args['-d'] = cmdArgs.database
        end

        if @new_resource.instance != nil
          args['-S'] = cmdArgs.instance
        end

        return args
      end

      def run_command(script, args)
        command = build_command(script, args)
        cmd = shell_out(command)
        cmd
      end

      def build_command(script, args)
        script_file.puts(script)
        script_file.close
        args['-i'] = "\"#{script_file.path}\""

        flags = args.map { |k, v| "#{k} #{v}" }.join(' ')

        command = "sqlcmd.exe #{flags}"
        command
      end

      def script_file
        @script_file ||= Tempfile.open(['chef-script', '.sql'])
      end
    end
  end
end
