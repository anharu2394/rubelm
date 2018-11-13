require 'opal-parser'
module Rubelm::Html
  def self.def_tags(*tags)
    tags.each do |tag_name|
      define_method(tag_name) {|attributes = {}, children = []| 
        node = {
          nodeName: tag_name,
          attributes: attributes,
          children: children
        }
        node
      }
    end
  end
end
