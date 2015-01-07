require 'pathname'

action :unzip do
	filepath = @new_resource.archive_path
	backuppath = @new_resource.backup_path
	
	if filepath.end_with?('.zip')
		cache_dir = "#{Chef::Config[:file_cache_path]}/database"
		zippedFileName = "#{Pathname.new(filepath).basename}"
		unzippedDirectoryName = zippedFileName.gsub('.zip', '')
		unzippedFileDirectory = "#{cache_dir}/#{unzippedDirectoryName}"


		backup_path_exists = ::File.exist?(backuppath)
		Chef::Log.info("#{backuppath} #{backup_path_exists ? 'already exists.' : "does not exist, will unzip #{filepath} to #{unzippedFileDirectory}"}")
		windows_zipfile unzippedFileDirectory do
			 source filepath
			 action :unzip
			 not_if {backup_path_exists}
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