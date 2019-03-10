# frozen_string_literal: true

module Rubelm::Component
  def component(state, actions)
    yield state, actions
  end
end
