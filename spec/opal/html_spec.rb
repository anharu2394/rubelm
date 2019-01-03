require "spec_helper"
Rubelm::Html.def_tags('div','p')
include Rubelm::Html
describe "test html" do
  describe 'div' do
    it 'div' do
      node = div()
      expect(node.name).to eq("div")
      expect(node.attributes).to eq({})
      expect(node.children).to eq([])
    end
    it 'attributes only class' do
      node = div({class: "test"})
      expect(node.name).to eq("div")
      expect(node.attributes).to eq({class: "test"})
      expect(node.children).to eq([])
    end
    it 'attributes' do
      node = div({class: "test", id: "t"})
      expect(node.name).to eq("div")
      expect(node.attributes).to eq({class: "test", id: "t"})
      expect(node.children).to eq([])
    end
    it 'include text' do
      node = div({class: "test", id: "t"}, "hello")
      expect(node.name).to eq("div")
      expect(node.attributes).to eq({class: "test", id: "t"})
      expect(node.children).to eq(['hello'])
    end
    it 'include number' do
      node = div({class: "test", id: "t"},33)
      expect(node.name).to eq("div")
      expect(node.attributes).to eq({class: "test", id: "t"})
      expect(node.children).to eq([33])
    end
    it 'children' do
      node = div({},[div()])
      expect(node.name).to eq("div")
      expect(node.attributes).to eq({})
      expect(node.children.length).to eq(1)
      expect(node.children[0].name).to eq("div")
      expect(node.children[0].attributes).to eq({})
      expect(node.children[0].children).to eq([])
    end
    it 'children attributes' do
      node = div({class:"test",id:"t"},[div({class:"inner",id:"i"})])
      expect(node.name).to eq("div")
      expect(node.attributes).to eq({class: "test", id: "t"})
      expect(node.children.length).to eq(1)
      expect(node.children[0].name).to eq("div")
      expect(node.children[0].attributes).to eq({class: "inner", id: "i"})
      expect(node.children[0].children).to eq([])
    end
    it 'children are ele and text' do
      node = div({class:"test",id:"t"},['hello',div({class:"inner",id:"i"}),'yeah'])
      expect(node.name).to eq("div")
      expect(node.attributes).to eq({class: "test", id: "t"})
      expect(node.children.length).to eq(3)
      expect(node.children[0]).to eq("hello")
      expect(node.children[1].name).to eq("div")
      expect(node.children[1].attributes).to eq({class: "inner", id: "i"})
      expect(node.children[1].children).to eq([])
      expect(node.children[2]).to eq("yeah")
    end
  end
  describe 'p' do
    it 'p' do
      node = p()
      expect(node.name).to eq("p")
      expect(node.attributes).to eq({})
      expect(node.children).to eq([])
    end
    it 'children attributes' do
      node = div({class:"test",id:"t"},[p({class:"inner",id:"i"})])
      expect(node.name).to eq("div")
      expect(node.attributes).to eq({class: "test", id: "t"})
      expect(node.children.length).to eq(1)
      expect(node.children[0].name).to eq("p")
      expect(node.children[0].attributes).to eq({class: "inner", id: "i"})
      expect(node.children[0].children).to eq([])
    end
  end
  describe 'should cause an error' do
  end
end
