# frozen_string_literal: true

require 'spec_helper'
require 'browser'
require 'opal-browser'
Rubelm::Html.def_tags('div', 'p')
include Rubelm::Html
describe 'test vdom' do
  describe 'view render' do
    before(:each) do
      @document_body = Browser::DOM::Element.create('body')
      @document_body << Browser::DOM::Element.create('div').add_class('vdom-test')
      @root = @document_body.children.to_ary[0]
    end
    after do
      @document_body.children.to_ary[0].clear
      @document_body.children.to_ary[0].remove
    end
    let(:root) { @root }
    let(:root_child) { @root.children.to_ary[0] }
    describe 'div' do
      it 'div' do
        a = Rubelm::VDOM.render(div, root)
        expect(a.child.name).to eq('DIV')
      end
      it 'attributes only class' do
        a = Rubelm::VDOM.render(div(class: 'test'), root)
        expect(a.child[:class]).to eq('test')
      end
      it 'attributes' do
        a = Rubelm::VDOM.render(div(class: 'test', id: 't'), root)
        expect(a.child[:class]).to eq('test')
        expect(a.child[:id]).to eq('t')
      end
      it 'many attributes' do
        a = Rubelm::VDOM.render(div(class: 'testatt', id: 't', "data-url": '/opal'), root)
        expect(a.child[:class]).to eq('testatt')
        expect(a.child[:id]).to eq('t')
        expect(a.child['data-url']).to eq('/opal')
      end
      it 'include text' do
        a = Rubelm::VDOM.render(div({}, 'hello'), root)
        expect(a.child.text). to eq('hello')
      end
      it 'include text' do
        a = Rubelm::VDOM.render(div({}, 33), root)
        expect(a.child.text). to eq('33')
      end
      it 'include child' do
        a = Rubelm::VDOM.render(div({ id: 'outer' }, [div(id: 'inner')]), root)
        expect(a.child[:id]).to eq('outer')
        expect(a.child.child[:id]).to eq('inner')
      end
      it 'include child and text' do
        a = Rubelm::VDOM.render(div({ id: 'outer' }, [div({ id: 'inner' }, 'inner')]), root)
        expect(a.child[:id]).to eq('outer')
        expect(a.child.child[:id]).to eq('inner')
        expect(a.child.child.text).to eq('inner')
      end
    end
    describe 'p' do
      it 'include child and text' do
        a = Rubelm::VDOM.render(div({ id: 'outer' }, [p({ id: 'inner' }, 'inner')]), root)
        expect(a.child[:id]).to eq('outer')
        expect(a.child.child[:id]).to eq('inner')
        expect(a.child.child.text).to eq('inner')
      end
    end
    describe 'rDOM to vDOM' do
      it 'one div child' do
        root << Browser::DOM::Element.create('div')
        vdom = Rubelm::VDOM.recycle(root_child)
        expect(vdom.name).to eq('div')
        expect(vdom.attributes).to eq({})
        expect(vdom.children).to eq([])
      end
      it 'one p child' do
        root << Browser::DOM::Element.create('p')
        vdom = Rubelm::VDOM.recycle(root_child)
        expect(vdom.name).to eq('p')
        expect(vdom.attributes).to eq({})
        expect(vdom.children).to eq([])
      end
      it 'div child include attributes' do
        ele = Browser::DOM::Element.create('div')
        ele[:class] = 'test'
        root << ele
        vdom = Rubelm::VDOM.recycle(root_child)
        expect(vdom.name).to eq('div')
        expect(vdom.attributes).to eq(class: 'test')
        expect(vdom.children).to eq([])
      end
      it 'div child include attributes' do
        ele = Browser::DOM::Element.create('div')
        ele[:class] = 'test'
        ele[:id] = 't'
        root << ele
        vdom = Rubelm::VDOM.recycle(root_child)
        expect(vdom.attributes).to eq(class: 'test', id: 't')
        expect(vdom.children).to eq([])
      end
      it 'div child include attributes and string' do
        ele = Browser::DOM::Element.create('div')
        ele[:class] = 'test'
        ele[:id] = 't'
        ele.text = 'hello'
        root << ele
        vdom = Rubelm::VDOM.recycle(root_child)
        expect(vdom.name).to eq('div')
        expect(vdom.attributes).to eq(class: 'test', id: 't')
        expect(vdom.children).to eq(['hello'])
      end
      it 'div child include attributes has child which has attributes' do
        ele = Browser::DOM::Element.create('div')
        ele[:class] = 'test'
        ele[:id] = 't'
        inner_ele = Browser::DOM::Element.create('div')
        inner_ele[:class] = 'test'
        inner_ele[:id] = 't'
        ele << inner_ele
        root << ele
        vdom = Rubelm::VDOM.recycle(root_child)
        expect(vdom.name).to eq('div')
        expect(vdom.attributes).to eq(class: 'test', id: 't')
        expect(vdom.children.length).to eq(1)
        expect(vdom.children[0].name).to eq('div')
        expect(vdom.children[0].attributes).to eq(class: 'test', id: 't')
        expect(vdom.children[0].children).to eq([])
      end
    end
    describe 'change Rdom from new_node' do
      let(:result) { @root.children.to_ary[0] }
      it 'change string' do
        old_node = div({}, 'morning')
        doc = Rubelm::VDOM.render(old_node, root)
        new_node = div({}, 'night')
        new_doc = Rubelm::VDOM.patch(old_node, new_node, root)
        expect(result.name).to eq('DIV')
        expect(result.text). to eq('night')
      end
      it 'change tag' do
        old_node = p
        doc = Rubelm::VDOM.render(old_node, root)
        new_node = div
        new_doc = Rubelm::VDOM.patch(old_node, new_node, root)
        expect(result.name).to eq('DIV')
      end
      it 'change tag and attr' do
        old_node = p({})
        doc = Rubelm::VDOM.render(old_node, root)
        new_node = div(class: 'night')
        new_doc = Rubelm::VDOM.patch(old_node, new_node, root)
        expect(result.name).to eq('DIV')
        expect(result[:class]).to eq('night')
      end
      it 'change tag and its children' do
        old_node = p({})
        doc = Rubelm::VDOM.render(old_node, root)
        new_node = div({}, div)
        new_doc = Rubelm::VDOM.patch(old_node, new_node, root)
        expect(result.name).to eq('DIV')
        expect(result.child.name).to eq('DIV')
      end
      it 'change tag and its children and attr' do
        old_node = p({})
        doc = Rubelm::VDOM.render(old_node, root)
        new_node = div({ class: 'outer' }, div(class: 'inner'))
        new_doc = Rubelm::VDOM.patch(old_node, new_node, root)
        expect(result.name).to eq('DIV')
        expect(result.child.name).to eq('DIV')
        expect(result[:class]).to eq('outer')
        expect(result.child[:class]).to eq('inner')
      end
      it 'change one updated attr' do
        old_node = div(class: 'morning')
        doc = Rubelm::VDOM.render(old_node, root)
        new_node = div(class: 'night')
        new_doc = Rubelm::VDOM.patch(old_node, new_node, root)
        expect(result[:class]).to eq('night')
      end
      it 'change many updated attr' do
        old_node = div(
          class: 'morning',
          id: 't',
          "data-url": '/opal',
          "data-hoge": 'hoge'
        )
        doc = Rubelm::VDOM.render(old_node, root)
        new_node = div(
          class: 'night',
          id: 'a',
          "data-url": '/ruby',
          "data-hoge": 'hogehoge'
        )
        new_doc = Rubelm::VDOM.patch(old_node, new_node, root)
        expect(result[:class]).to eq('night')
        expect(result[:id]).to eq('a')
        expect(result['data-url']).to eq('/ruby')
        expect(result['data-hoge']).to eq('hogehoge')
      end
      it 'change many updated attr' do
        old_node = div({
                         class: 'morning',
                         id: 't',
                         "data-url": '/opal',
                         "data-hoge": 'hoge'
                       }, 'moring')
        doc = Rubelm::VDOM.render(old_node, root)
        new_node = div({
                         class: 'night',
                         id: 'a',
                         "data-url": '/ruby',
                         "data-hoge": 'hogehoge'
                       }, 'night')
        new_doc = Rubelm::VDOM.patch(old_node, new_node, root)
        expect(result[:class]).to eq('night')
        expect(result[:id]).to eq('a')
        expect(result['data-url']).to eq('/ruby')
        expect(result['data-hoge']).to eq('hogehoge')
        expect(result.text).to eq('night')
      end
      it 'change one updated attr and child attr' do
        old_node = div({ class: 'morning' }, [div(class: 'hello')])
        doc = Rubelm::VDOM.render(old_node, root)
        new_node = div({ class: 'night' }, div(class: 'bye'))
        new_doc = Rubelm::VDOM.patch(old_node, new_node, root)
        expect(result.class_name).to eq('night')
        expect(result.child.class_name).to eq('bye')
      end
      it 'increase one children' do
        old_node = div({}, [div, p])
        doc = Rubelm::VDOM.render(old_node, root)
        new_node = div({}, [p, div, p])
        new_doc = Rubelm::VDOM.patch(old_node, new_node, root)
        expect(result.children.to_ary.length).to eq(3)
      end
    end
  end
end
