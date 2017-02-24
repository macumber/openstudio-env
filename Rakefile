require_relative 'where_openstudio'

task :default => 'cli'

osw = File.join(File.dirname(__FILE__), 'compact_osw/compact.osw')
test_file = File.join(File.dirname(__FILE__), 'gem_env_info.rb')

desc "OpenStudio CLI"
task :cli do
  command = "\"#{$OS_EXE}\" #{test_file}"
  #puts command
  system(command)
end

desc "OpenStudio SO"
task :so do
  puts "SO"
end
