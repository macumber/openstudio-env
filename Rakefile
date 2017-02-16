require_relative 'where_openstudio'

task :default => 'cli'

osw = File.join(File.dirname(__FILE__), 'compact_osw/compact.osw')
test2 = File.join(File.dirname(__FILE__), 'test2.rb')

desc "OpenStudio CLI"
task :cli do
  command = "'#{$OS_EXE}' #{test2}"
  #puts command
  system(command)
end

desc "OpenStudio SO"
task :so do
  puts "SO"
end
