require 'json'
require 'rbconfig'

#puts "hello"

result = {}

result[:env] = {}
ENV.each_key {|k| result[:env][k] = ENV[k]}

result[:rb_config] = RbConfig::CONFIG

result[:gem] = {}
result[:gem][:version] = Gem::VERSION
result[:gem][:bindir] = Gem.bindir
result[:gem][:config_file] = Gem.config_file
#result[:gem][:configuration] = Gem.configuration # not useful
result[:gem][:default_bindir] = Gem.default_bindir
result[:gem][:default_cert_path] = Gem.default_cert_path
result[:gem][:default_dir] = Gem.default_dir
result[:gem][:default_exec_format] = Gem.default_exec_format
result[:gem][:default_key_path] = Gem.default_key_path
result[:gem][:default_path] = Gem.default_path
result[:gem][:default_rubygems_dirs] = Gem.default_rubygems_dirs
result[:gem][:default_sources] = Gem.default_sources
result[:gem][:dir] = Gem.dir
result[:gem][:host] = Gem.host
#result[:gem][:latest_rubygems_version] = Gem.latest_rubygems_version # fails, should fix
result[:gem][:path] = Gem.path
result[:gem][:path_separator] = Gem.path_separator
#result[:gem][:paths] = Gem.paths # not useful
result[:gem][:platforms] = Gem.platforms
result[:gem][:ruby] = Gem.ruby
result[:gem][:ruby_engine] = Gem.ruby_engine
result[:gem][:ruby_version] = Gem.ruby_version
result[:gem][:rubygems_version] = Gem.rubygems_version
result[:gem][:sources] = Gem.sources
result[:gem][:suffix_pattern] = Gem.suffix_pattern
result[:gem][:suffixes] = Gem.suffixes
result[:gem][:user_dir] = Gem.user_dir
result[:gem][:user_home] = Gem.user_home
result[:gem][:win_platform] = Gem.win_platform?

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

result[:specs_all] = []
Gem::Specification.each do |spec|
  result[:specs_all] << {name: spec.name, version: spec.version, dir: spec.spec_dir}
end

result[:specs_loaded] = []
Gem.loaded_specs.each_value do |spec|
  result[:specs_loaded] << {name: spec.name, version: spec.version, dir: spec.spec_dir}
end

puts JSON::pretty_generate(result)

# run a simulation
do_sim = true

if do_sim
  require_relative 'where_openstudio'
  osw = File.join(File.dirname(__FILE__), 'compact_osw/compact.osw')
  command = "\"#{$OS_EXE}\" run -w \"#{osw}\""
  puts command
  system(command)
end