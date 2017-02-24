require_relative 'gem_env_info'

# run a simulation
do_sim = true

if do_sim
  require_relative 'where_openstudio'
  osw = File.join(File.dirname(__FILE__), 'compact_osw/compact.osw')
  
  # Remove old test output
  ['reports', 'run', 'out.osw', 'run/eplusout.sql'].each do |item|
    item_path = File.join(File.dirname(__FILE__), 'compact_osw', item)
    if File.exist?(item_path) || Dir.exists?(item_path)
      FileUtils.rm_r(item_path)
    end
  end
  
  command = "\"#{$OS_EXE}\" run -w \"#{osw}\""
  puts command
  system(command)
  
  # If the test is successful, there are no ruby load errors
  if File.exist?(File.join(File.dirname(__FILE__), 'compact_osw/run/eplusout.sql'))
    puts "Run passed"
  else
    puts "Run failed"
  end  
end