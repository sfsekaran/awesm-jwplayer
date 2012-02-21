require 'fileutils'

task :default => [:build]

desc 'Build awesm.swf'
task :build do
  puts 'Compiling awesm.swf...'
  puts ''
  puts %x{cd plugins/awesm; sh build.sh}
  puts ''
  puts 'Done!'
end
