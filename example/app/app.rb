# frozen_string_literal: true

require 'rubelm'
require 'opal-browser'
Rubelm::Html.def_tags('div')
include Rubelm::Html
view =
  div({ class: 'hello' }, [
        div({ class: 'world' }, 'hello, world!')
      ])
Rubelm.main(view, $document.body)
