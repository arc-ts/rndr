require 'bundler/gem_tasks'
require 'coveralls/rake/task'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
Coveralls::RakeTask.new

task :default => :spec
task :coveralls => [ :spec, :features, 'coveralls:push' ]
