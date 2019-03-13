# frozen_string_literal: true

if RUBY_ENGINE == 'opal'
  require 'opal'
  require 'opal-browser'
  require 'rubelm/main'
else
  require 'opal'
  require 'opal-browser'
  require 'rubelm/version'
  Opal.append_path(__dir__)
end

module Rubelm
end
