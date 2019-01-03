require 'opal-parser'
module Rubelm::Html
  def self.def_tags(*tags)
    tags.each do |tag_name|
      define_method(tag_name) {|attributes = {}, children = []| 
        if children.instance_of?(Array)
          Rubelm::VDOM::VNode.new(tag_name, attributes, children)
        else
          Rubelm::VDOM::VNode.new(tag_name, attributes, [children])
        end
      }
    end
  end
end
