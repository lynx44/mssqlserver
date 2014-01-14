require 'pathname'

action :unzip do
	filepath = @new_resource.archive_path
	backuppath = @new_resource.backup_path
	
	if filepath.end_with?('.zip')
		cache_dir = "#{Chef::Config[:file_cache_path]}/database"
		zippedFileName = "#{Pathname.new(filepath).basename}"
		unzippedDirectoryName = zippedFileName.gsub('.zip', '')
		unzippedFileDirectory = "#{cache_dir}/#{unzippedDirectoryName}"
		
		windows_zipfile unzippedFileDirectory do
			 source filepath
			 action :unzip
			 not_if {::File.exist?("#{backuppath}")}
		end
		
		ruby_block "rename file" do
			block do
				if ::File.directory?(unzippedFileDirectory)
					Dir.foreach(unzippedFileDirectory) {|dirfilepath| 
						Chef::Log.info("File #{dirfilepath} found in #{unzippedFileDirectory}")
						if dirfilepath.end_with?(".bak") 
							Chef::Log.info("Database backup found at #{dirfilepath}")
							path = "#{unzippedFileDirectory}/#{dirfilepath}"
							::File.rename(path,backuppath)
						end
					}
					Dir.rmdir(unzippedFileDirectory)
				end
			end
		end
	else
		ruby_block "rename backup file" do
			block do
				::File.rename(filepath,backuppath)
			end
		end
	end
end