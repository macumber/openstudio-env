puts 'hello'

puts "GEM_PATH = #{ENV['GEM_PATH']}"
puts "GEM_HOME = #{ENV['GEM_HOME']}"

require 'openstudio'
puts "OpenStudio::openStudioVersion = #{OpenStudio::openStudioVersion}"

require 'openstudio-workflow'
puts "OpenStudio::Workflow::VERSION = #{OpenStudio::Workflow::VERSION}"

require 'openstudio-standards'
puts "OpenstudioStandards::VERSION = #{OpenstudioStandards::VERSION}"

begin
  require 'parallel'
rescue LoadError
  puts 'parallel failed to load'
end

Gem.loaded_specs.each_pair do |name, spec|
  puts "#{name} loaded from #{spec.spec_dir}"
end

puts 'goodbye'