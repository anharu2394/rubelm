# frozen_string_literal: true

require 'opal'
require 'opal-browser'
module Rubelm
  def self.main(view, element)
    VDOM.render(view, element)
  end
  require 'rubelm/html'
  require 'rubelm/vdom'
end
