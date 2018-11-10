require 'bundler'
Bundler.require
require 'opal/rspec'
sprockets_env = Opal::RSpec::SprocketsEnvironment.new(spec_pattern='spec/opal/*_spec.{rb,opal}')
run Opal::Sprockets::Server.new(sprockets: sprockets_env) { |s|
  s.main = 'custom_sprockets_runner'
	s.append_path 'spec/opal'
  sprockets_env.add_spec_paths_to_sprockets
  s.debug = false
}
