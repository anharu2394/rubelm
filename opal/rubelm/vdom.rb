module Rubelm::Vdom 
	require "opal-browser"
  def self.render(view,root)
    self.create(view,root)
  end
  def self.create(vdom,parent)
    element = Browser::DOM::Element.create(vdom[:nodeName])
    vdom[:attributes].each do |name, val|
      element.set(name,val)
    end
    vdom[:children].each do |child|
        child.instance_of?(Hash) ? create(child, element) : element.text = child
    end
    parent << element
  end
  def self.recycle(ele)
    attributes = {}
    children = []
    ele.attributes.each  do |name, value|
      attributes[name] = value
    end
    ele.children.to_ary.each do |node|
      node.instance_of?(Browser::DOM::Element) ? children << recycle(node) : children << node.whole
    end
    node = {
      nodeName: ele.name.downcase,
      attributes: attributes,
      children: children
    }
  end
  def self.patch(old_node,new_node,root)
    ele = root.elements.to_ary[0]
    root.elements.to_ary[0].name = 'DIV'
    ele.text = new_node[:children][0]
    root
  end
end
