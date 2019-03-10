# frozen_string_literal: true

require 'opal'
require 'opal-browser'
module Rubelm
  def self.main(view, state, actions, element)
    VDOM.render(view, state, actions, element)
  end
  require 'rubelm/html'
  require 'rubelm/vdom'
  require 'rubelm/component'
end

include Rubelm::Component
