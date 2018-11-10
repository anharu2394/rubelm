require "rubelm"
require "opal-browser"
include Rubelm::Html
view = div({class: "test"},"a")
Rubelm::main(view,$document.body)
