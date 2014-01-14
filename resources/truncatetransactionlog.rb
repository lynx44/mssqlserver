actions :run

attribute :server, :kind_of => String
attribute :username, :kind_of => String
attribute :password, :kind_of => String
attribute :database, :kind_of => String
attribute :instance, :kind_of => String

def initialize(*args)
  super
  @action = :run
end