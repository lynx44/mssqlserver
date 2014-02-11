actions :run, :drop
default_action :run

attribute :file_path, :kind_of => String
attribute :server, :kind_of => String
attribute :username, :kind_of => String
attribute :password, :kind_of => String
attribute :database, :kind_of => String #the name of the database
attribute :instance, :kind_of => String #the sql instance to connect to (such as "localhost\sqlexpress") (optional)
attribute :data_directory, :kind_of => String #the directory to restore the files to (optional)
attribute :with, :kind_of => Array
attribute :timeout, :kind_of => Integer