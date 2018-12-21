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
      $document.body.element_children.to_ary[1].remove
    end
    let(:root) {$document.body.element_children.to_ary[1]}
    let(:root_child) {$document.body.element_children.to_ary[1].elements.to_ary[0]}
    describe 'div' do
      it 'div' do
        a = Rubelm::VDOM::render(div(),root)
        expect(a.child.name).to eq("DIV")
      end
      it 'attributes only class' do
        a = Rubelm::VDOM::render(div({class: "test"}),root)
        expect(a.child[:class]).to eq("test")
      end
      it 'attributes' do
        a = Rubelm::VDOM::render(div({class: "test",id:"t"}),root)
        expect(a.child[:class]).to eq("test")
        expect(a.child[:id]).to eq("t")
      end
      it 'many attributes' do
        a = Rubelm::VDOM::render(div({class: "testatt",id:"t", "data-url": "/opal"}), root)
        expect(a.child[:class]).to eq("testatt")
        expect(a.child[:id]).to eq("t")
        expect(a.child["data-url"]).to eq("/opal")
      end
      it 'include text' do
        a = Rubelm::VDOM::render(div({},"hello"),root)
        expect(a.child.text). to eq("hello")
      end
      it 'include text' do
        a = Rubelm::VDOM::render(div({},33),root)
        expect(a.child.text). to eq("33")
      end
      it 'include child' do
        a = Rubelm::VDOM::render(div({id: "outer"},[div({id: "inner"})]),root)
        expect(a.child[:id]).to eq("outer")
        expect(a.child.child[:id]).to eq("inner")
      end
      it 'include child and text' do
        a = Rubelm::VDOM::render(div({id: "outer"},[div({id: "inner"},"inner")]),root)
        expect(a.child[:id]).to eq("outer")
        expect(a.child.child[:id]).to eq("inner")
        expect(a.child.child.text).to eq("inner")
      end
    end
    describe 'p' do
      it 'include child and text' do
        a = Rubelm::VDOM::render(div({id: "outer"},[p({id: "inner"},"inner")]),root)
        expect(a.child[:id]).to eq("outer")
        expect(a.child.child[:id]).to eq("inner")
        expect(a.child.child.text).to eq("inner")
      end
    end
    describe 'rDOM to vDOM' do
      it 'one div child' do
        root << Browser::DOM::Element::create('div') 
        vdom = Rubelm::VDOM::recycle(root_child)
        expect(vdom).to eq({
          nodeName: "div",
          attributes: {},
          children: []
        })
      end
      it 'one p child' do
        root <<  Browser::DOM::Element::create('p')
        vdom = Rubelm::VDOM::recycle(root_child)
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
        vdom = Rubelm::VDOM::recycle(root_child)
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
        vdom = Rubelm::VDOM::recycle(root_child)
        expect(vdom).to eq({
          nodeName: "div",
          attributes: {class: "test",id: "t"},
          children: []
        })
      end
      it 'div child include attributes and string' do
        ele = Browser::DOM::Element::create('div')
        ele[:class] = "test"
        ele[:id] = "t"
        ele.text = "hello"
        root << ele
        vdom = Rubelm::VDOM::recycle(root_child)
        expect(vdom).to eq({
          nodeName: "div",
          attributes: {class: "test",id: "t"},
          children: ["hello"]
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
        vdom = Rubelm::VDOM::recycle(root_child)
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
    describe 'change Rdom from new_node' do
      it 'change string' do
        old_node = div({},'morning')
        doc = Rubelm::VDOM::render(old_node,root)
        new_node = {
          nodeName: "div",
          attributes: {},
          children: ["night"]
        }
        new_doc = Rubelm::VDOM::patch(old_node, new_node, root)
        expect(new_doc.child.name).to eq("DIV")
        expect(new_doc.child.text). to eq("night")
      end
      it 'change tag' do
        old_node = p({})
        doc = Rubelm::VDOM::render(old_node,root)
        new_node = {
          nodeName: "div",
          attributes: {},
          children: []
        }
        new_doc = Rubelm::VDOM::patch(old_node, new_node, root)
        expect(new_doc.child.name).to eq("DIV")
      end
      it 'change tag and attr' do
        old_node = p({})
        doc = Rubelm::VDOM::render(old_node,root)
        new_node = {
          nodeName: "div",
          attributes: {class: "night"},
          children: []
        }
        new_doc = Rubelm::VDOM::patch(old_node, new_node, root)
        expect(new_doc.child.name).to eq("DIV")
        expect(new_doc.child[:class]).to eq("night")
      end
      it 'change tag and its children' do
        old_node = p({})
        doc = Rubelm::VDOM::render(old_node,root)
        new_node = {
          nodeName: "div",
          attributes: {},
          children: [
            {
              nodeName: "div",
              attributes: {},
              children: []
            }
          ]
        }
        new_doc = Rubelm::VDOM::patch(old_node, new_node, root)
        expect(new_doc.child.name).to eq("DIV")
        expect(new_doc.child.child.name).to eq("DIV")
      end
      it 'change tag and its children and attr' do
        old_node = p({})
        doc = Rubelm::VDOM::render(old_node,root)
        new_node = {
          nodeName: "div",
          attributes: {class: "outer"},
          children: [
            {
              nodeName: "div",
              attributes: {class: "inner"},
              children: []
            }
          ]
        }
        new_doc = Rubelm::VDOM::patch(old_node, new_node, root)
        expect(new_doc.child.name).to eq("DIV")
        expect(new_doc.child.child.name).to eq("DIV")
        expect(new_doc.child[:class]).to eq("outer")
        expect(new_doc.child.child[:class]).to eq("inner")
      end
      it 'change one updated attr' do
        old_node = div({class:"morning"})
        doc = Rubelm::VDOM::render(old_node,root)
        new_node = {
          nodeName: "div",
          attributes: {class: "night"},
          children: []
        }
        new_doc = Rubelm::VDOM::patch(old_node, new_node, root)
        expect(new_doc.child[:class]).to eq("night")
      end
      it 'change many updated attr' do
        old_node = div({
          class:"morning", 
          id:"t",
          "data-url": "/opal",
          "data-hoge": "hoge"
        })
        doc = Rubelm::VDOM::render(old_node,root)
        new_node = {
          nodeName: "div",
          attributes: {
            class: "night",
            id: "a",
            "data-url": "/ruby",
            "data-hoge": "hogehoge"
          },
          children: []
        }
        new_doc = Rubelm::VDOM::patch(old_node, new_node, root)
        expect(new_doc.child[:class]).to eq("night")
        expect(new_doc.child[:id]).to eq("a")
        expect(new_doc.child["data-url"]).to eq("/ruby")
        expect(new_doc.child["data-hoge"]).to eq("hogehoge")
      end
      it 'change many updated attr' do
        old_node = div({
          class:"morning", 
          id:"t",
          "data-url": "/opal",
          "data-hoge": "hoge"
        },"moring")
        doc = Rubelm::VDOM::render(old_node,root)
        new_node = {
          nodeName: "div",
          attributes: {
            class: "night",
            id: "a",
            "data-url": "/ruby",
            "data-hoge": "hogehoge"
          },
          children: ["night"]
        }
        new_doc = Rubelm::VDOM::patch(old_node, new_node, root)
        expect(new_doc.child[:class]).to eq("night")
        expect(new_doc.child[:id]).to eq("a")
        expect(new_doc.child["data-url"]).to eq("/ruby")
        expect(new_doc.child["data-hoge"]).to eq("hogehoge")
        expect(new_doc.child.text).to eq("night")
      end
      it 'change one updated attr and child attr' do
        old_node = div({class:"morning"},[div({class:"hello"})])
        doc = Rubelm::VDOM::render(old_node,root)
        new_node = {
          nodeName: "div",
          attributes: {class: "night"},
          children: [
            {
              nodeName: "div",
              attributes: {class: "bye"},
              children: []
            }
          ]
        }
        new_doc = Rubelm::VDOM::patch(old_node, new_node, root)
        expect(new_doc.child[:class]).to eq("night")
        expect(new_doc.child.child[:class]).to eq("bye")
      end
    end
  end
end
