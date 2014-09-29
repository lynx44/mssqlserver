actions :create
default_action :create

attribute :database, :kind_of => String #the name of the database
attribute :instance, :kind_of => String #the sql instance to connect to (such as "localhost\sqlexpress") (optional)
attribute :username, :kind_of => String
attribute :password, :kind_of => String