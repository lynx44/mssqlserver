actions :run

attribute :dacpacpath, :kind_of => String
attribute :server, :kind_of => String
attribute :username, :kind_of => String
attribute :password, :kind_of => String
attribute :database, :kind_of => String #the name of the database
attribute :sqlaction, :kind_of => Symbol, :default => :publish, :equal_to => [:publish, :script]
attribute :variables, :kind_of => Hash
#attribute :instance, :kind_of => String #the sql instance to connect to (such as "localhost\sqlexpress") (optional)

def initialize(*args)
  super
  @action = :run
end