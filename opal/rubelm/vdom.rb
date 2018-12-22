require "opal-browser"
module Rubelm::VDOM
  require "rubelm/vdom/vnode"
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
    if old_node[:nodeName] != new_node[:nodeName]
      ele.remove
      create(new_node,root)
    else
      if ele.attributes.namespace != new_node[:attributes]
        ele.attributes.merge!(new_node[:attributes])
      end
      new_node[:children].each_with_index do |child, i|
        child.instance_of?(Hash) ? patch(old_node[:children][i], child, ele) : ele.text = child
      end
    end
    root
  end
end
