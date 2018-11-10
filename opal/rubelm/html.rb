module Rubelm::Html
  def div(attributes={},children=[])
		node = {
			nodeName: "div",
			attributes: attributes,
			children: children
		}
		node
  end
end
