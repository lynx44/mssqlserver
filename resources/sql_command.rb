actions :run, :bat
default_action :run

attribute :command, :kind_of => String
attribute :script, :kind_of => String
attribute :username, :kind_of => String
attribute :password, :kind_of => String
attribute :database, :kind_of => String
attribute :instance, :kind_of => String
attribute :timeout, :kind_of => Integer

attribute :batch_path, :kind_of => String