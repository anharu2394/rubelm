class Rubelm::VDOM::VNode
  attr_reader :node_name, :attributes, :children
  def initialize(name, attributes, children)
    if !attributes.instance_of?(Hash)
      raise ArgumentError, "attributes must be Hash instance."
    end
    if !children.instance_of?(Array)
      raise ArgumentError, "children must be Array instance."
    end
    @node_name = name
    @attributes = attributes
    @children = children
  end
end
