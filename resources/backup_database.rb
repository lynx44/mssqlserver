actions :run

attribute :destination, :kind_of => String
attribute :database, :kind_of => String

def initialize(*args)
  super
  @action = :run
end