# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubelm/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubelm'
  spec.version       = Rubelm::VERSION
  spec.authors       = ['Anharu']
  spec.email         = ['haruan2394@gmail.com']

  spec.summary       = ' Rubelm'
  spec.description   = ' Ruby framework for building client web apps'
  spec.homepage      = 'https://github.com/anharu2394/rubelm'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'opal'
  spec.add_dependency 'opal-browser'
  spec.add_dependency 'opal-sprockets'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'opal-test-unit'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'

  # spec.add_development_dependency 'capybara'
  # spec.add_development_dependency 'chromedriver-helper'
  spec.add_development_dependency 'opal-rspec', '0.7.1'
  spec.add_development_dependency 'rack'
  # spec.add_development_dependency 'selenium-webdriver'
end
