require "spec_helper"
include Rubelm::Html
describe "test html" do
  it 'div' do
    expect(div()).to eq({
			nodeName: "div",
			attributes: {},
			children: []
		})
	end
	it 'div attributes only class' do
		expect(div({class: "test"})).to eq({
			nodeName: "div",
			attributes: {class: "test"},
			children: []
		})	
	end
	it 'div attributes' do
		expect(div({class: "test", id: "t"})).to eq({
			nodeName: "div",
			attributes: {class: "test", id: "t"},
			children: []
		})	
	end
	it 'div children' do
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
	it 'div children attributes' do
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
end
