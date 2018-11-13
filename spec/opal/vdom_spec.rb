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
    end
  end
end
