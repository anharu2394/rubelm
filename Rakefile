require "bundler/gem_tasks"
#require "rspec/core/rake_task"
require "webrick"
#RSpec::Core::RakeTask.new(:spec)

#task :default => :spec


require 'opal/rspec/rake_task'
Opal::RSpec::RakeTask.new(:default) do |server, task|
  task.pattern = 'spec/opal/*_spec.rb'
  task.default_path = 'spec/opal'
  server.append_path 'opal'
	server.debug = true
end
