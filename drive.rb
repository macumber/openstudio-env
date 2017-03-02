require 'fileutils'
require 'json'
require_relative 'where_openstudio'

# DLM: this will do the install 
#require_relative 'install_test_gems'

test_gems = File.expand_path('test_gems', File.dirname(__FILE__))
test_gems_020 = File.join(test_gems, '0_2_0')
test_gems_021 = File.join(test_gems, '0_2_1')
test_gems_031 = File.join(test_gems, '0_3_1')
test_gems_100 = File.join(test_gems, '1_0_0')
test_gems_my = File.join(test_gems, 'my')
test_gems_all = File.join(test_gems, 'all')

include_me = File.expand_path('test_includes', File.dirname(__FILE__))
include_me_a = File.join(include_me, 'a')
include_me_b = File.join(include_me, 'b')
include_me_c = File.join(include_me, 'c')

verbose = ""
#verbose = "--verbose" # tests won't pass with this on since it does not print JSON

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
          next if test_version && (test_version == expected_test_version)
          test_version = spec[:version]
        end
      end
      
      if test_version != expected_test_version
        puts "expected_test_version = #{expected_test_version}, test_version = #{test_version}"
        status = "Failed"
      end
      
      test_spec_version = result[:test_spec_version]
      if test_spec_version != expected_test_version
        puts "expected_test_version = #{expected_test_version}, test_spec_version = #{test_spec_version}"
        status = "Failed"
      end
    end
    
  end
  
  puts status
  puts
end

Dir.glob("out*.json").each {|f| FileUtils.rm(f)}

#system('bundle update')

#system("\"#{$OS_EXE}\" #{verbose} measure -t compact_osw/measures")

#system("\"#{$OS_EXE}\" #{verbose} gem_list")

#FileUtils.rm_rf(test_gems_my) if File.exists?(test_gems_my)
#system("\"#{$OS_EXE}\" #{verbose} --gem_home \"#{test_gems_my}\" gem_install test") #DLM: not working

#FileUtils.rm_rf(test_gems_my) if File.exists?(test_gems_my)
#system("\"#{$OS_EXE}\" #{verbose} --gem_home \"#{test_gems_my}\" gem_install test 0.2.0") #DLM: not working

run_test("\"#{$OS_EXE}\" #{verbose} test.rb", 'out1.json', nil, nil)
run_test("bundle exec \"#{$OS_EXE}\" #{verbose} test.rb", 'out2.json', nil, "0.2.1") #DLM: not working
run_test("bundle exec \"#{$OS_EXE}\" #{verbose} --include \"#{include_me_a}\" test.rb", 'out3.json', "A", "0.2.1") #DLM: not working
run_test("bundle exec ruby -I '#{$OS_RB}' test.rb", 'out4.json', nil, "0.2.1")
run_test("rake -I '#{$OS_RB}'", 'out5.json')
run_test("bundle exec rake -I '#{$OS_RB}'", 'out6.json', nil, "0.2.1")

ENV['RUBYLIB'] = nil
ENV['GEM_HOME'] = nil
ENV['GEM_PATH'] = "#{$PAT_GEMS}#{File::PATH_SEPARATOR}#{$PAT_GEMS}#{File::ALT_SEPARATOR}bundler#{File::ALT_SEPARATOR}gems"
#run_test("\"#{$OS_EXE}\" #{verbose} test.rb", 'out7.json')
run_test("\"#{$PAT_RUBY}\" -I '#{$OS_RB}' test.rb", 'out8.json')

ENV['RUBYLIB'] = nil
ENV['GEM_HOME'] = nil
ENV['GEM_PATH'] = test_gems_020
run_test("\"#{$OS_EXE}\" #{verbose} test.rb", 'out9.json', nil, "0.2.0")
run_test("\"#{$OS_EXE}\" #{verbose} --gem_path \"#{test_gems_031}\" test.rb", 'out10.json', nil, "0.3.1")
run_test("\"#{$OS_EXE}\" #{verbose} --gem_path \"#{test_gems_100}\" --gem_path \"#{test_gems_031}\" test.rb", 'out11.json', nil, "1.0.0")

ENV['RUBYLIB'] = nil
ENV['GEM_HOME'] = test_gems_020
ENV['GEM_PATH'] = nil
run_test("\"#{$OS_EXE}\" #{verbose} test.rb", 'out12.json', nil, "0.2.0")
run_test("\"#{$OS_EXE}\" #{verbose} --gem_home \"#{test_gems_031}\" test.rb", 'out13.json', nil, "0.3.1")

ENV['RUBYLIB'] = nil
ENV['GEM_HOME'] = nil
ENV['RUBYLIB'] = include_me_a
run_test("\"#{$OS_EXE}\" #{verbose} test.rb", 'out14.json', "A", nil)
run_test("\"#{$OS_EXE}\" #{verbose} --include \"#{include_me_b}\" test.rb", 'out15.json', "B", nil)
run_test("\"#{$OS_EXE}\" #{verbose} --include \"#{include_me_c}\" --include \"#{include_me_b}\" test.rb", 'out16.json', "C", nil)

