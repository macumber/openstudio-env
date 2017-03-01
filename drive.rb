require 'fileutils'
require 'json'
require_relative 'where_openstudio'

verbose = ""
#verbose = "--verbose"

# DLM: run install_test_gems to use this stuff
test_gems = File.expand_path('test_gems', File.dirname(__FILE__))
test_gems_020 = File.join(test_gems, '0_2_0')
test_gems_021 = File.join(test_gems, '0_2_1')
test_gems_031 = File.join(test_gems, '0_3_1')
test_gems_100 = File.join(test_gems, '1_0_0')
test_gems_all = File.join(test_gems, 'all')

include_me = File.expand_path('test_includes', File.dirname(__FILE__))
include_me_a = File.join(include_me, 'a')
include_me_b = File.join(include_me, 'b')

def run_test(command, out_file, expected_include_me = nil, expected_test_version = nil)
  FileUtils.rm(out_file) if File.exists?(out_file)
  
  command = command + ' > ' + out_file 
  puts command 
  
  status = "Did not complete"
  if system(command)
    
    status = "Passed"
    
    result = nil
    File.open(out_file, 'r') do |f|
      begin
        result = JSON.parse(f.read, :symbolize_names => true)
      rescue JSON::ParserError
        status = "JSON parse error"
      end
    end
    
    if result
      include_me = result[:include_me]
      if include_me != expected_include_me
        puts "expected_include_me = #{expected_include_me}, include_me = #{include_me}"
        status = "Failed"
      end
      
      test_version = nil
      result[:specs_all].each do |spec|
        if spec[:name] == "test"
          test_version = spec[:version]
        end
      end
      
      if test_version != expected_test_version
        puts "expected_test_version = #{expected_test_version}, test_version = #{test_version}"
        status = "Failed"
      end
    end
    
  end
  
  puts status
  puts
end

Dir.glob("out*.json").each {|f| FileUtils.rm(f)}

#system('bundle update')

#system("\"#{$OS_EXE}\" measure -t compact_osw/measures")

#run_test("\"#{$OS_EXE}\" #{verbose} test.rb", 'out1.json')
#run_test("bundle exec \"#{$OS_EXE}\" #{verbose} test.rb", 'out2.json')
#run_test("ruby -I '#{$OS_RB}' test.rb", 'out3.json') # DLM: is this a valid test case since it relies on system gems?
#run_test("bundle exec ruby -I '#{$OS_RB}' test.rb", 'out4.json')
#run_test("rake -I '#{$OS_RB}'", 'out5.json')
#run_test("bundle exec rake -I '#{$OS_RB}'", 'out6.json')

ENV['GEM_PATH'] = "#{$PAT_GEMS}#{File::PATH_SEPARATOR}#{$PAT_GEMS}#{File::ALT_SEPARATOR}bundler#{File::ALT_SEPARATOR}gems"
#run_test("\"#{$OS_EXE}\" #{verbose} test.rb", 'out7.json')
run_test("\"#{$PAT_RUBY}\" -I '#{$OS_RB}' test.rb", 'out8.json')

ENV['GEM_PATH'] = test_gems_020
ENV['OPENSTUDIO_GEM_PATH'] = ""
run_test("\"#{$OS_EXE}\" #{verbose} test.rb", 'out9.json', nil, "0.2.0")

ENV['GEM_PATH'] = test_gems_020
ENV['OPENSTUDIO_GEM_PATH'] = test_gems_031
#run_test("\"#{$OS_EXE}\" #{verbose} test.rb", 'out10.json')
run_test("\"#{$OS_EXE}\" #{verbose} --gem_path \"#{test_gems_100}\" test.rb", 'out11.json', nil, "1.0.0")

ENV['RUBYLIB'] = include_me_a
run_test("\"#{$OS_EXE}\" #{verbose} test.rb", 'out12.json', "A", "1.0.0")
run_test("\"#{$OS_EXE}\" #{verbose} --include \"#{include_me_b}\" test.rb", 'out13.json', "B", "1.0.0")