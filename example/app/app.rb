require "rubelm"
require "opal-browser"
include Rubelm::Html
view = div({class: "hello"},[
    div({class:"world"}, "hello, world!")
  ])
Rubelm::main(view,$document.body)
