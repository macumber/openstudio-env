require 'fileutils'
require_relative 'where_openstudio'

def run_test(command, out_file)
  FileUtils.rm(out_file) if File.exists?(out_file)
  if system(command + ' > ' + out_file)
    puts command + ' Passed'
  else
    puts command + ' Failed'
  end
end

run_test('bundle update', 'bundle.out')
FileUtils.rm('bundle.out') if File.exists?('bundle.out')

run_test("\"#{$OS_EXE}\" --verbose gem_env_info.rb", 'out1.json')
#run_test("bundle exec \"#{$OS_EXE}\" --verbose gem_env_info.rb", 'out2.json')
run_test("ruby -I '#{$OS_RB}' gem_env_info.rb", 'out3.json')
#run_test("bundle exec ruby -I '#{$OS_RB}' gem_env_info.rb", 'out4.json')
#run_test("rake -I '#{$OS_RB}'", 'out5.json')
#run_test("bundle exec rake -I '#{$OS_RB}'", 'out6.json')

ENV['GEM_PATH'] = "#{$PAT_GEMS}#{File::PATH_SEPARATOR}#{$PAT_GEMS}#{File::ALT_SEPARATOR}bundler#{File::ALT_SEPARATOR}gems"
run_test("\"#{$OS_EXE}\" --verbose gem_env_info.rb", 'out7.json')
run_test("ruby -I '#{$OS_RB}' gem_env_info.rb", 'out8.json')