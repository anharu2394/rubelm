require "spec_helper"
Rubelm::Html.def_tags('div','p')
include Rubelm::Html
describe "test vdom" do
  describe 'view render' do
    before do
      $document.body << Browser::DOM::Element.create("div").add_class("vdom-test")
    end
    after do
      $document.body.element_children.to_ary[1].clear
    end
    let(:root) {$document.body.element_children.to_ary[1]}
    let(:root_child) {$document.body.element_children.to_ary[1].elements.to_ary[0]}
    describe 'div' do
      it 'div' do
        a = Rubelm::Vdom::render(div(),root)
        expect(a.child.name).to eq("DIV")
      end
      it 'attributes only class' do
        a = Rubelm::Vdom::render(div({class: "test"}),root)
        expect(a.child[:class]).to eq("test")
      end
      it 'attributes' do
        a = Rubelm::Vdom::render(div({class: "test",id:"t"}),root)
        expect(a.child[:class]).to eq("test")
        expect(a.child[:id]).to eq("t")
      end
      it 'many attributes' do
        a = Rubelm::Vdom::render(div({class: "testatt",id:"t", "data-url": "/opal"}), root)
        expect(a.child[:class]).to eq("testatt")
        expect(a.child[:id]).to eq("t")
        expect(a.child["data-url"]).to eq("/opal")
      end
      it 'include text' do
        a = Rubelm::Vdom::render(div({},"hello"),root)
        expect(a.child.text). to eq("hello")
      end
      it 'include child' do
        a = Rubelm::Vdom::render(div({id: "outer"},[div({id: "inner"})]),root)
        expect(a.child[:id]).to eq("outer")
        expect(a.child.child[:id]).to eq("inner")
      end
      it 'include child and text' do
        a = Rubelm::Vdom::render(div({id: "outer"},[div({id: "inner"},"inner")]),root)
        expect(a.child[:id]).to eq("outer")
        expect(a.child.child[:id]).to eq("inner")
        expect(a.child.child.text).to eq("inner")
      end
    end
    describe 'p' do
      it 'include child and text' do
        a = Rubelm::Vdom::render(div({id: "outer"},[p({id: "inner"},"inner")]),root)
        expect(a.child[:id]).to eq("outer")
        expect(a.child.child[:id]).to eq("inner")
        expect(a.child.child.text).to eq("inner")
      end
    end
    describe 'rDOM to vDOM' do
      it 'one div child' do
        root << Browser::DOM::Element::create('div') 
        vdom = Rubelm::Vdom::recycle(root_child)
        expect(vdom).to eq({
          nodeName: "div",
          attributes: {},
          children: []
        })
      end
      it 'one p child' do
        root <<  Browser::DOM::Element::create('p')
        vdom = Rubelm::Vdom::recycle(root_child)
        expect(vdom).to eq({
          nodeName: "p",
          attributes: {},
          children: []
        })
      end
      it 'div child include attributes' do
        ele = Browser::DOM::Element::create('div')
        ele[:class] = "test"
        root << ele
        vdom = Rubelm::Vdom::recycle(root_child)
        expect(vdom).to eq({
          nodeName: "div",
          attributes: {class: "test"},
          children: []
        })
      end
      it 'div child include attributes' do
        ele = Browser::DOM::Element::create('div')
        ele[:class] = "test"
        ele[:id] = "t"
        root << ele
        vdom = Rubelm::Vdom::recycle(root_child)
        expect(vdom).to eq({
          nodeName: "div",
          attributes: {class: "test",id: "t"},
          children: []
        })
      end
      it 'div child include attributes has child which has attributes' do
        ele = Browser::DOM::Element::create('div')
        ele[:class] = "test"
        ele[:id] = "t"
        inner_ele = Browser::DOM::Element::create('div')
        inner_ele[:class] = "test"
        inner_ele[:id] = "t"
        ele << inner_ele
        root << ele
        vdom = Rubelm::Vdom::recycle(root_child)
        expect(vdom).to eq({
          nodeName: "div",
          attributes: {class: "test",id: "t"},
          children: [
            {
              nodeName: "div",
              attributes: {class: "test",id: "t"},
              children: []
            }]
        })
      end
    end
  end
end
