# frozen_string_literal: true

require 'opal-browser'
module Rubelm::VDOM
  require 'rubelm/vdom/vnode'
  def self.render(view, state, actions, root)
    if view.class == Proc
      create(view.call(state, actions), root)
    else
      create(view, root)
    end
  end

  def self.create(vdom, parent)
    element = Browser::DOM::Element.create(vdom.name)
    vdom.attributes.each do |name, val|
      element.set(name, val)
    end
    vdom.children.each do |child|
      child.instance_of?(VNode) ? create(child, element) : element.text = child
    end
    parent << element
  end

  def self.create_element(vdom, parent = nil)
    element = Browser::DOM::Element.create(vdom.name)
    vdom.attributes.each do |name, val|
      element.set(name, val)
    end
    vdom.children.each do |child|
      child.instance_of?(VNode) ? create(child, element) : element.text = child
    end
    if !parent
      element
    else
      parent << element
    end
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

  def self.patch(old_node, new_node, root, index = 0)
    ele = root
    if !old_node
      create(new_node, root)
    elsif !new_node
    elsif old_node.name != new_node.name
      new_element = create_element(new_node)
      ele.children.to_ary[index].replace new_element
    else
      if old_node.attributes != new_node.attributes
        ele.children.to_ary[index].attributes.merge!(new_node.attributes)
      end
      new_count = new_node.children.length
      old_count = old_node.children.length
      i = 0
      while i < new_count || i < old_count
        new_node.children[i].instance_of?(VNode) ? patch(old_node.children[i], new_node.children[i], ele.children.to_ary[index], i) : ele.children.to_ary[index].text = new_node.children[i]
        i += 1
      end
    end
    root
  end
end
