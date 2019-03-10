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
  test 'state can see in html' do
    state = Struct.new(:count)
    initial_state = state.new(0)
    view = component do |state, _actions|
      div({}, state.count)
    end
    a = Rubelm::VDOM.render(view, initial_state, nil, @@root)
    assert_equal('0', a.child.inner_html)
    @@root.remove
  end
  test 'state can see in class' do
    state = Struct.new(:name)
    initial_state = state.new('anharu')
    view = component do |state, _actions|
      div(class: state.name)
    end
    a = Rubelm::VDOM.render(view, initial_state, nil, @@root)
    assert_equal('0', a.child.inner_html)
    @@root.remove
  end
end
