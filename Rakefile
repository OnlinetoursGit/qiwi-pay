require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :c => :console
task :console do
  sh 'bundle exec irb -r qiwi-pay'
end
