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
  test 'simple set_count action' do
    State = Struct.new(:count)
    initial_state = State.new(0)
    class Actions
      def set_count(value)
        { count: value }
      end
    end
    view = component do |state, actions|
      div({}, [
            div({}, 'Count:' + state.count.to_s),
            input(type: 'button', onclick: actions.set_count(10), class: 'button', value: 'Set count')
          ])
    end
    a = Rubelm::VDOM.render(view, initial_state, Actions, @@root)
    `document.body.querySelector('.button').click()`
    assert_equal('10', a.child.inner_html)
    @@root.remove
  end
  test 'up action' do
    State = Struct.new(:count)
    initial_state = State.new(0)
    class Actions
      def up(value)
        action do |state|
          { count: state.count + value }
        end
      end
    end
    view = component do |state, _actions|
      div({}, [
            div({}, 'Count:' + state.count.to_s),
            input(type: 'button', onclick: actions.up(1), class: 'button', value: 'Set count')
          ])
    end
    a = Rubelm::VDOM.render(view, initial_state, Actions, @@root)
    `document.body.querySelector('.button').click()`
    `document.body.querySelector('.button').click()`
    assert_equal('a', a.child.class_name)
    @@root.remove
  end
end
