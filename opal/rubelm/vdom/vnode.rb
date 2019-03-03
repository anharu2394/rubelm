# frozen_string_literal: true

class Rubelm::VDOM::VNode
  attr_reader :name, :attributes, :children
  def initialize(name, attributes, children)
    # Argument check
    raise ArgumentError, 'attributes must be Hash instance.' unless attributes.respond_to? :to_h
    raise ArgumentError, 'children must be Array instance.'  unless children.respond_to? :to_a

    @attributes = attributes.to_h
    @children = children.to_a
    @name = name
  end
end
