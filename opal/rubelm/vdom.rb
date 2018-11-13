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
    if vdom[:children].class == Array
      vdom[:children].each do |child|
        create(child, element)
      end
    else
      element.text = vdom[:children]
    end
    parent << element
  end
  def self.recycle(ele)
    attributes = {}
    children = []
    ele.attributes.each  do |name, value|
      attributes[name] = value
    end
    ele.elements.to_ary.each do |node|
      children << recycle(node)
    end
    node = {
      nodeName: ele.name.downcase,
      attributes: attributes,
      children: children
    }
  end
end
