require_relative 'where_openstudio'

osw = File.join(File.dirname(__FILE__), 'compact_osw/compact.osw')
test2 = File.join(File.dirname(__FILE__), 'test2.rb')

#command = "'#{$OS_EXE}' run -w #{osw}"
command = "'#{$OS_EXE}' #{test2}"

#puts command
system(command)