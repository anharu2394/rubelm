# frozen_string_literal: true

require 'test_helper'
Rubelm::Html.def_tags('div', 'p')
include Rubelm::Html

class VDOMRenderTest < Opal::Test::Unit::TestCase
  setup do
    @@test_body = Browser::DOM::Element.create('body')

    @@test_body << Browser::DOM::Element.create('div').add_class('vdom-test')
    @@root = @@test_body.children.to_ary[0]
  end
  test 'state' do
    state = Struct.new(:count)
    initial_state = state.new(0)
    view = component do |state, _actions|
      div({}, state.count)
    end
    a = Rubelm::VDOM.render(view, initial_state, nil, @@root)
    assert_equal(a.child.value, '0')
    @@root.remove
  end
end
