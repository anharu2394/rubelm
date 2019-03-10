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
  test 'component div' do
    view = component do |_state, _actions|
      div
    end
    a = Rubelm::VDOM.render(view, nil, nil, @@root)
    assert_equal(a.child.name, 'DIV')
    @@root.remove
  end
  test 'component include child and text' do
    view = component do |_state, _actions|
      div({ id: 'outer' }, [div({ id: 'inner' }, 'inner')])
    end
    a = Rubelm::VDOM.render(view, nil, nil, @@root)
    assert_equal(a.child[:id], 'outer')
    assert_equal(a.child.child[:id], 'inner')
    assert_equal(a.child.child.text, 'inner')
    @@root.remove
  end
end
