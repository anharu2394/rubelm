# frozen_string_literal: true

require 'test_helper'
Rubelm::Html.def_tags('div', 'p')
include Rubelm::Html

class VDOMChangeTest < Opal::Test::Unit::TestCase
  setup do
    @@test_body = Browser::DOM::Element.create('body')

    @@test_body << Browser::DOM::Element.create('div').add_class('vdom-test')
    @@root = @@test_body.children.to_ary[0]
  end
  test 'change string' do
    old_node = div({}, 'morning')
    doc = Rubelm::VDOM.render(old_node, @@root)
    new_node = div({}, 'night')
    new_doc = Rubelm::VDOM.patch(old_node, new_node, @@root)
    result = @@root.children.to_ary[0]
    assert_equal(result.name, 'DIV')
    assert_equal(result.text, 'night')
  end
  test 'change tag' do
    old_node = p
    doc = Rubelm::VDOM.render(old_node, @@root)
    new_node = div
    new_doc = Rubelm::VDOM.patch(old_node, new_node, @@root)
    result = @@root.children.to_ary[0]
    assert_equal(result.name, 'DIV')
  end
  test 'change tag and attr' do
    old_node = p({})
    doc = Rubelm::VDOM.render(old_node, @@root)
    new_node = div(class: 'night')
    new_doc = Rubelm::VDOM.patch(old_node, new_node, @@root)
    result = @@root.children.to_ary[0]
    assert_equal(result.name, 'DIV')
    assert_equal(result[:class], 'night')
  end
  test 'change tag and its children' do
    old_node = p({})
    doc = Rubelm::VDOM.render(old_node, @@root)
    new_node = div({}, div)
    new_doc = Rubelm::VDOM.patch(old_node, new_node, @@root)
    result = @@root.children.to_ary[0]
    assert_equal(result.name, 'DIV')
    assert_equal(result.child.name, 'DIV')
  end
  test 'change tag and its children and attr' do
    old_node = p({})
    doc = Rubelm::VDOM.render(old_node, @@root)
    new_node = div({ class: 'outer' }, div(class: 'inner'))
    new_doc = Rubelm::VDOM.patch(old_node, new_node, @@root)
    result = @@root.children.to_ary[0]
    assert_equal(result.name, 'DIV')
    assert_equal(result.child.name, 'DIV')
    assert_equal(result[:class], 'outer')
    assert_equal(result.child[:class], 'inner')
  end
  test 'change one updated attr' do
    old_node = div(class: 'morning')
    doc = Rubelm::VDOM.render(old_node, @@root)
    new_node = div(class: 'night')
    new_doc = Rubelm::VDOM.patch(old_node, new_node, @@root)
    result = @@root.children.to_ary[0]
    assert_equal(result[:class], 'night')
  end
  test 'change many updated attr' do
    old_node = div(
      class: 'morning',
      id: 't',
      "data-url": '/opal',
      "data-hoge": 'hoge'
    )
    doc = Rubelm::VDOM.render(old_node, @@root)
    new_node = div(
      class: 'night',
      id: 'a',
      "data-url": '/ruby',
      "data-hoge": 'hogehoge'
    )
    new_doc = Rubelm::VDOM.patch(old_node, new_node, @@root)
    result = @@root.children.to_ary[0]
    assert_equal(result[:class], 'night')
    assert_equal(result[:id], 'a')
    assert_equal(result['data-url'], '/ruby')
    assert_equal(result['data-hoge'], 'hogehoge')
  end
  test 'change many updated attr' do
    old_node = div({
                     class: 'morning',
                     id: 't',
                     "data-url": '/opal',
                     "data-hoge": 'hoge'
                   }, 'moring')
    doc = Rubelm::VDOM.render(old_node, @@root)
    new_node = div({
                     class: 'night',
                     id: 'a',
                     "data-url": '/ruby',
                     "data-hoge": 'hogehoge'
                   }, 'night')
    new_doc = Rubelm::VDOM.patch(old_node, new_node, @@root)
    result = @@root.children.to_ary[0]
    assert_equal(result[:class], 'night')
    assert_equal(result[:id], 'a')
    assert_equal(result['data-url'], '/ruby')
    assert_equal(result['data-hoge'], 'hogehoge')
    assert_equal(result.text, 'night')
  end
  test 'change one updated attr and child attr' do
    old_node = div({ class: 'morning' }, [div(class: 'hello')])
    doc = Rubelm::VDOM.render(old_node, @@root)
    new_node = div({ class: 'night' }, div(class: 'bye'))
    new_doc = Rubelm::VDOM.patch(old_node, new_node, @@root)
    result = @@root.children.to_ary[0]
    assert_equal(result.class_name, 'night')
    assert_equal(result.child.class_name, 'bye')
  end
  test 'increase one children' do
    old_node = div({}, [div, p])
    doc = Rubelm::VDOM.render(old_node, @@root)
    new_node = div({}, [p, div, p])
    new_doc = Rubelm::VDOM.patch(old_node, new_node, @@root)
    result = @@root.children.to_ary[0]
    assert_equal(result.children.to_ary.length, 3)
  end
end
