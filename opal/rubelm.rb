require "opal"
module Rubelm
	def self.main(view,element)
		Vdom::render(view,element)
	end
  require "rubelm/html"
	require "rubelm/vdom"
end
