require 'opal-parser'
module Rubelm::Html
  def self.def_tags(*tags)
    tags.each do |tag_name|
      define_method(tag_name) {|attributes = {}, children = []| 
        if children.instance_of?(Array)
          node = {
            nodeName: tag_name,
            attributes: attributes,
            children: children
          }
        else
          node = {
            nodeName: tag_name,
            attributes: attributes,
            children: [children]
          }
        end
        node
      }
    end
  end
end
