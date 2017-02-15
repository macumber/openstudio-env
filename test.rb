#os = 'C:\openstudio-2.0.2\bin\openstudio.exe'
os = 'E:\openstudio\build\Products\Debug\openstudio.exe'

osw = File.join(File.dirname(__FILE__), 'compact_osw/compact.osw')
test2 = File.join(File.dirname(__FILE__), 'test2.rb')

#command = "#{os} run -w #{osw}"
command = "#{os} #{test2}"

puts command
system(command)