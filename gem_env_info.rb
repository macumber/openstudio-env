require 'json'
require 'rbconfig'
require 'rubygems'
require 'rubygems/version'

begin
  require 'include_me'
rescue LoadError
  $INCLUDE_ME = nil
end

result = {}

result[:env] = {}
ENV.each_key {|k| result[:env][k] = ENV[k]}

result[:rb_config] = RbConfig::CONFIG
result[:include_me] = $INCLUDE_ME

test_spec_version = nil
begin
  test_spec = Gem::Specification.find_by_name('test')
  if test_spec
    test_spec_version = test_spec.version
  end
rescue Exception
end
result[:test_spec_version] = test_spec_version

result[:load_path] = $LOAD_PATH

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
