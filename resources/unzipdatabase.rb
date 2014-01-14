actions :unzip

attribute :archivepath, :kind_of => String
attribute :backuppath, :kind_of => String

def initialize(name, run_context=nil)
  super
  @action = :unzip
end
