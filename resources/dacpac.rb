actions :run
default_action :run

attribute :dacpac_path, :kind_of => String
attribute :server, :kind_of => String
attribute :username, :kind_of => String
attribute :password, :kind_of => String
attribute :database, :kind_of => String #the name of the database
attribute :sql_action, :kind_of => Symbol, :default => :publish, :equal_to => [:publish, :script]
attribute :variables, :kind_of => Hash