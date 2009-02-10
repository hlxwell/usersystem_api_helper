# Install hook code here
puts "Copying files..."
dir = "initializers"
["usersystem_api_config.rb"].each do |rb_file|
	dest_file = File.join(RAILS_ROOT, "config", dir, rb_file)
	src_file = File.join(File.dirname(__FILE__) , dir, rb_file)
	FileUtils.cp_r(src_file, dest_file)
end
puts "Files copied - Installation complete!"
