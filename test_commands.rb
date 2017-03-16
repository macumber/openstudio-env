require 'open3'
require 'fileutils'

require_relative 'where_openstudio'

verbose = ""
#verbose = "--verbose" 

def run_command(cmd)
  stdout, stderr, status = Open3.capture3(cmd)
  
  status = status.exitstatus
  
  error = false
  if /ERROR/.match(stdout) || /ERROR/.match(stderr)
    error = true
  end
  
  puts cmd
  if status != 0
    puts "error occurred, exit code #{status}"
  elsif error
    puts "error occurred, exit code 0 (incorrect exit code)"
  else 
    puts "success"
  end
  
  puts
end

def clean(cleandir, testdir)
  FileUtils.rm_rf(testdir) if File.exists?(testdir)
  FileUtils.cp_r(cleandir, testdir)
end

measures = File.expand_path('measures', File.dirname(__FILE__))
test_measures = File.expand_path('test_measures', File.dirname(__FILE__))
clean(measures, test_measures)
model_measure = File.join(test_measures, 'model_measure')
energyplus_measure = File.join(test_measures, 'energyplus_measure')
report_measure = File.join(test_measures, 'report_measure')

models = File.expand_path('models', File.dirname(__FILE__))
test_models = File.expand_path('test_models', File.dirname(__FILE__))
clean(models, test_models)
untitled_osm = File.join(test_models, 'untitled.osm')

include_me = File.expand_path('test_includes', File.dirname(__FILE__))
include_me_a = File.join(include_me, 'a/include_me.rb')

compact_osw = File.expand_path('compact_osw/compact.osw', File.dirname(__FILE__))

run_command("\"#{$OS_EXE}\" #{verbose} -h")
run_command("\"#{$OS_EXE}\" #{verbose} --help")
run_command("\"#{$OS_EXE}\" #{verbose} -e \"puts 'hello'\" -h")
run_command("\"#{$OS_EXE}\" #{verbose} -e \"puts 'hello'\" list_commands")

run_command("\"#{$OS_EXE}\" #{verbose} run -h")
run_command("\"#{$OS_EXE}\" #{verbose} run --help")
#run_command("\"#{$OS_EXE}\" #{verbose} run -w") # defaults to './workflow.osw'
run_command("\"#{$OS_EXE}\" #{verbose} run -m -w \"#{compact_osw}\"")
run_command("\"#{$OS_EXE}\" #{verbose} run --measures_only --workflow \"#{compact_osw}\"")
run_command("\"#{$OS_EXE}\" #{verbose} run -w \"#{compact_osw}\"")
run_command("\"#{$OS_EXE}\" #{verbose} run --workflow \"#{compact_osw}\"")
run_command("\"#{$OS_EXE}\" #{verbose} run -p -w \"#{compact_osw}\"")
run_command("\"#{$OS_EXE}\" #{verbose} run --postprocess_only --workflow \"#{compact_osw}\"")
#run_command("\"#{$OS_EXE}\" #{verbose} run -s 80 -w \"#{compact_osw}\"")
#run_command("\"#{$OS_EXE}\" #{verbose} run --socket 80 --workflow \"#{compact_osw}\"")
run_command("\"#{$OS_EXE}\" #{verbose} run --debug -w \"#{compact_osw}\"")
run_command("\"#{$OS_EXE}\" #{verbose} run --debug --workflow \"#{compact_osw}\"")

run_command("\"#{$OS_EXE}\" #{verbose} gem_list -h")
run_command("\"#{$OS_EXE}\" #{verbose} gem_list --help")
run_command("\"#{$OS_EXE}\" #{verbose} gem_list")
 
run_command("\"#{$OS_EXE}\" #{verbose} measure -h")
run_command("\"#{$OS_EXE}\" #{verbose} measure --help")
clean(measures, test_measures)
run_command("\"#{$OS_EXE}\" #{verbose} measure -t \"#{test_measures}\"")
clean(measures, test_measures)
run_command("\"#{$OS_EXE}\" #{verbose} measure --update_all \"#{test_measures}\"")
clean(measures, test_measures)
run_command("\"#{$OS_EXE}\" #{verbose} measure -u \"#{model_measure}\"") 
clean(measures, test_measures)
run_command("\"#{$OS_EXE}\" #{verbose} measure --update \"#{model_measure}\"")
clean(measures, test_measures)
run_command("\"#{$OS_EXE}\" #{verbose} measure -a \"#{model_measure}\"") 
clean(measures, test_measures)
run_command("\"#{$OS_EXE}\" #{verbose} measure --compute_arguments \"#{model_measure}\"")
clean(measures, test_measures)
run_command("\"#{$OS_EXE}\" #{verbose} measure -a \"#{untitled_osm}\" \"#{model_measure}\"") 
clean(measures, test_measures)
run_command("\"#{$OS_EXE}\" #{verbose} measure --compute_arguments \"#{untitled_osm}\" \"#{model_measure}\"")
#run_command("\"#{$OS_EXE}\" #{verbose} measure -s 8080")
#run_command("\"#{$OS_EXE}\" #{verbose} measure --start_server 8080")

run_command("\"#{$OS_EXE}\" #{verbose} update -h")
run_command("\"#{$OS_EXE}\" #{verbose} update --help")
run_command("\"#{$OS_EXE}\" #{verbose} update \"#{test_models}\"")
run_command("\"#{$OS_EXE}\" #{verbose} update -k \"#{test_models}\"")
run_command("\"#{$OS_EXE}\" #{verbose} update --keep \"#{test_models}\"")

run_command("\"#{$OS_EXE}\" #{verbose} execute_ruby_script -h") 
run_command("\"#{$OS_EXE}\" #{verbose} execute_ruby_script --help") 
run_command("\"#{$OS_EXE}\" #{verbose} execute_ruby_script \"#{include_me_a}\"")
run_command("\"#{$OS_EXE}\" #{verbose} \"#{include_me_a}\"")

run_command("\"#{$OS_EXE}\" #{verbose} openstudio_version -h")
run_command("\"#{$OS_EXE}\" #{verbose} openstudio_version --help")
run_command("\"#{$OS_EXE}\" #{verbose} openstudio_version")

run_command("\"#{$OS_EXE}\" #{verbose} energyplus_version -h")
run_command("\"#{$OS_EXE}\" #{verbose} energyplus_version --help")
run_command("\"#{$OS_EXE}\" #{verbose} energyplus_version")

run_command("\"#{$OS_EXE}\" #{verbose} ruby_version -h")
run_command("\"#{$OS_EXE}\" #{verbose} ruby_version --help")
run_command("\"#{$OS_EXE}\" #{verbose} ruby_version")

run_command("\"#{$OS_EXE}\" #{verbose} list_commands -h")
run_command("\"#{$OS_EXE}\" #{verbose} list_commands --help")
run_command("\"#{$OS_EXE}\" #{verbose} list_commands")