# frozen_string_literal: true

require 'bundler'
Bundler.require

run Opal::Sprockets::Server.new { |s|
  s.append_path 'app'
  # s.append_path 'client'

  s.debug = true
  s.main = 'app'
  # s.index_path = 'index.html'
}
