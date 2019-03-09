# frozen_string_literal: true

require 'bundler'
Bundler.require
Bundler::GemHelper.install_tasks

require 'bundler/gem_tasks'
require 'opal/test/unit/rake_task'
require 'opal/rspec/rake_task'
require 'rubelm'
require 'opal-browser'

# Opal.append_path './spec/opal'
# Opal.append_path './test'
Opal.use_gem 'rubelm'
Opal::Test::Unit::RakeTask.new(:default, File.expand_path('test', __dir__), runner: :chrome)

Opal::RSpec::RakeTask.new(:rspec) do |_server, task|
  task.pattern = 'spec/opal/*_spec.rb'
  task.default_path = 'spec/opal'
  # task.runner = :node
  # _server.append_path 'opal'
  _server.debug = true
end
