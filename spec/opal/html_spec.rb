require "spec_helper"
Rubelm::Html.def_tags('div','p')
include Rubelm::Html
describe "test html" do
  describe 'div' do
    it 'div' do
      expect(div()).to eq({
        nodeName: "div",
        attributes: {},
        children: []
      })
    end
    it 'attributes only class' do
      expect(div({class: "test"})).to eq({
        nodeName: "div",
        attributes: {class: "test"},
        children: []
      })	
    end
    it 'attributes' do
      expect(div({class: "test", id: "t"})).to eq({
        nodeName: "div",
        attributes: {class: "test", id: "t"},
        children: []
      })	
    end
    it 'include text' do
      expect(div({class: "test", id: "t"}, "hello")).to eq({
        nodeName: "div",
        attributes: {class: "test", id: "t"},
        children: ['hello']
      })	
    end
    it 'include number' do
      expect(div({class: "test", id: "t"}, 33)).to eq({
        nodeName: "div",
        attributes: {class: "test", id: "t"},
        children: [33]
      })	
    end
    it 'children' do
      expect(div({},[div()])).to eq({
        nodeName: "div",
        attributes: {},
        children: [
          {
            nodeName: "div",
            attributes: {},
            children: []
          }
        ]
      })
    end
    it 'children attributes' do
      expect(div({class:"test",id:"t"},[div({class:"inner",id:"i"})])).to eq({
        nodeName: "div",
        attributes: {class: "test", id: "t"},
        children: [
          {
            nodeName: "div",
            attributes: {class: "inner", id: "i"},
            children: []
          }
        ]
      })
    end
    it 'children are ele and text' do
      expect(div({class:"test",id:"t"},['hello',div({class:"inner",id:"i"}),'yeah'])).to eq({
        nodeName: "div",
        attributes: {class: "test", id: "t"},
        children: [
          'hello',
          {
            nodeName: "div",
            attributes: {class: "inner", id: "i"},
            children: []
          },
          'yeah'
        ]
      })
    end
  end
  describe 'p' do
    it 'p' do
      expect(p()).to eq({
        nodeName: "p",
        attributes: {},
        children: []
      })
    end
    it 'children attributes' do
      expect(div({class:"test",id:"t"},[p({class:"inner",id:"i"})])).to eq({
        nodeName: "div",
        attributes: {class: "test", id: "t"},
        children: [
          {
            nodeName: "p",
            attributes: {class: "inner", id: "i"},
            children: []
          }
        ]
      })
    end
  end
end
