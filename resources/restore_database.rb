actions :run, :drop, :script
default_action :run

attribute :file_path, :kind_of => String
attribute :username, :kind_of => String
attribute :password, :kind_of => String
attribute :database, :kind_of => String #the name of the database
attribute :instance, :kind_of => String #the sql instance to connect to (such as "localhost\sqlexpress") (optional)
attribute :data_directory, :kind_of => String #the directory to restore the data files to (optional). will restore log files to this same location if log_directory is not specified
attribute :log_directory, :kind_of => String #the directory to restore the log files to (optional)
attribute :ignore_logs, :kind_of => [TrueClass, FalseClass], :default => false
attribute :with, :kind_of => Array
attribute :timeout, :kind_of => Integer

attribute :script_path, :kind_of => String