require "opal-browser"
module Rubelm::VDOM
  require "rubelm/vdom/vnode"
  def self.render(view,root)
    self.create(view,root)
  end
  def self.create(vdom,parent)
    element = Browser::DOM::Element.create(vdom.name)
    vdom.attributes.each do |name, val|
      element.set(name,val)
    end
    vdom.children.each do |child|
        child.instance_of?(VNode) ? create(child, element) : element.text = child
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
    VNode.new(ele.name.downcase, attributes, children)
  end
  def self.patch(old_node,new_node,root)
    ele = root.elements.to_ary[0]
    if old_node.name != new_node.name
      ele.remove
      create(new_node,root)
    else
      if ele.attributes.namespace != new_node.attributes
        ele.attributes.merge!(new_node.attributes)
      end
      new_node.children.each_with_index do |child, i|
        child.instance_of?(VNode) ? patch(old_node.children[i], child, ele) : ele.text = child
      end
    end
    root
  end
end
