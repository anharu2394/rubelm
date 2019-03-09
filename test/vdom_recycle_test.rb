# frozen_string_literal: true

require 'test_helper'
Rubelm::Html.def_tags('div', 'p')
include Rubelm::Html

class VDOMRecycleTest < Opal::Test::Unit::TestCase
  setup do
    @@test_body = Browser::DOM::Element.create('body')

    @@test_body << Browser::DOM::Element.create('div').add_class('vdom-test')
    @@root = @@test_body.children.to_ary[0]
  end
  test 'one div child' do
    @@root << Browser::DOM::Element.create('div')
    vdom = Rubelm::VDOM.recycle(@@root.children.to_ary[0])
    assert_equal(vdom.name, 'div')
    assert_equal(vdom.attributes, {})
    assert_equal(vdom.children, [])
  end
  test 'one p child' do
    @@root << Browser::DOM::Element.create('p')
    vdom = Rubelm::VDOM.recycle(@@root.children.to_ary[0])
    assert_equal(vdom.name, 'p')
    assert_equal(vdom.attributes, {})
    assert_equal(vdom.children, [])
  end
  test 'div child include attributes' do
    ele = Browser::DOM::Element.create('div')
    ele[:class] = 'test'
    @@root << ele
    vdom = Rubelm::VDOM.recycle(@@root.children.to_ary[0])
    assert_equal(vdom.name, 'div')
    assert_equal(vdom.attributes, class: 'test')
    assert_equal(vdom.children, [])
  end
  test 'div child include attributes' do
    ele = Browser::DOM::Element.create('div')
    ele[:class] = 'test'
    ele[:id] = 't'
    @@root << ele
    vdom = Rubelm::VDOM.recycle(@@root.children.to_ary[0])
    assert_equal(vdom.attributes, class: 'test', id: 't')
    assert_equal(vdom.children, [])
  end
  test 'div child include attributes and string' do
    ele = Browser::DOM::Element.create('div')
    ele[:class] = 'test'
    ele[:id] = 't'
    ele.text = 'hello'
    @@root << ele
    vdom = Rubelm::VDOM.recycle(@@root.children.to_ary[0])
    assert_equal(vdom.name, 'div')
    assert_equal(vdom.attributes, class: 'test', id: 't')
    assert_equal(vdom.children, ['hello'])
  end
  test 'div child include attributes has child which has attributes' do
    ele = Browser::DOM::Element.create('div')
    ele[:class] = 'test'
    ele[:id] = 't'
    inner_ele = Browser::DOM::Element.create('div')
    inner_ele[:class] = 'test'
    inner_ele[:id] = 't'
    ele << inner_ele
    @@root << ele
    vdom = Rubelm::VDOM.recycle(@@root.children.to_ary[0])
    assert_equal(vdom.name, 'div')
    assert_equal(vdom.attributes, class: 'test', id: 't')
    assert_equal(vdom.children.length, 1)
    assert_equal(vdom.children[0].name, 'div')
    assert_equal(vdom.children[0].attributes, class: 'test', id: 't')
    assert_equal(vdom.children[0].children, [])
  end
end
