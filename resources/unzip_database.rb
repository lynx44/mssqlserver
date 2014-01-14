actions :unzip

attribute :archive_path, :kind_of => String
attribute :backup_path, :kind_of => String

def initialize(name, run_context=nil)
  super
  @action = :unzip
end
