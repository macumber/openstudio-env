require 'json'

result = {}

result[:path] = ENV['PATH']
result[:gem_path] = ENV['GEM_PATH']
result[:gem_home] = ENV['GEM_HOME']

require 'openstudio'
result[:openstudio_version] = OpenStudio::openStudioVersion
result[:openstudio_module] = OpenStudio::getOpenStudioModule

require 'openstudio-workflow'
result[:openstudio_workflow_version] = OpenStudio::Workflow::VERSION

require 'openstudio-standards'
result[:openstudio_standards_version] = OpenstudioStandards::VERSION

begin
  require 'parallel'
  result[:parallel_loaded] = true
rescue LoadError
  result[:parallel_loaded] = false
end

Gem.loaded_specs.each_pair do |name, spec|
  result[name] = spec.spec_dir
end

puts JSON::pretty_generate(result)