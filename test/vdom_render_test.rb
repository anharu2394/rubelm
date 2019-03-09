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

  test 'div' do
    a = Rubelm::VDOM.render(div({}), @@root)
    assert_equal(a.child.name, 'DIV')
    @@root.remove
  end
  test 'attributes only class' do
    a = Rubelm::VDOM.render(div(class: 'test'), @@root)
    assert_equal(a.child[:class], 'test')
    @@root.remove
  end
  test 'attributes' do
    a = Rubelm::VDOM.render(div(class: 'test', id: 't'), @@root)
    assert_equal(a.child[:class], 'test')
    assert_equal(a.child[:id], 't')
    @@root.remove
  end
  test 'many attributes' do
    a = Rubelm::VDOM.render(div(class: 'testatt', id: 't', "data-url": '/opal'), @@root)
    assert_equal(a.child[:class], 'testatt')
    assert_equal(a.child[:id], 't')
    assert_equal(a.child['data-url'], '/opal')
    @@root.remove
  end
  test 'include text' do
    a = Rubelm::VDOM.render(div({}, 'hello'), @@root)
    assert_equal(a.child.text, 'hello')
    @@root.remove
  end
  test 'include text' do
    a = Rubelm::VDOM.render(div({}, 33), @@root)
    assert_equal(a.child.text, '33')
    @@root.remove
  end
  test 'include child' do
    a = Rubelm::VDOM.render(div({ id: 'outer' }, [div(id: 'inner')]), @@root)
    assert_equal(a.child[:id], 'outer')
    assert_equal(a.child.child[:id], 'inner')
    @@root.remove
  end
  test 'include child and text' do
    a = Rubelm::VDOM.render(div({ id: 'outer' }, [div({ id: 'inner' }, 'inner')]), @@root)
    assert_equal(a.child[:id], 'outer')
    assert_equal(a.child.child[:id], 'inner')
    assert_equal(a.child.child.text, 'inner')
    @@root.remove
  end
end
