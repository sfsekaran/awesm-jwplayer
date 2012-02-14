require 'fileutils'

task :default => [:build]

task :build do
  puts 'Compiling awesm.swf...'
  puts ''
  puts %x{cd plugins/awesm; sh build.sh}
  puts ''
  puts 'Done!'
end
