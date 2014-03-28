require_relative "../../spec_helper"
require "mendel/visualizers/base"

describe Mendel::Visualizers::Base do

  let(:klass) { described_class }

  describe "initialization" do

    it "requires exactly 2 lists" do
      expect{klass.new([1,2], [3,4])}.not_to raise_error
      expect{klass.new([1,2], [3,4], [5,6])}.to raise_error(klass.const_get('InvalidListCount'))
      expect{klass.new([1,2])}.to raise_error(klass.const_get('InvalidListCount'))
    end

    it "limits list length" do
      over = klass.max_list_length + 1
      expect{klass.new((1..over).to_a, (1..10).to_a)}.to raise_error(klass.const_get('ListsTooLarge'))
    end

  end

  describe "after initialization" do

    let(:list1)      { (1..10).to_a              }
    let(:list2)      { (1..10).map {|i| i + 0.1} }
    let(:visualizer) { klass.new(list1, list2)   }

    it "can mark a square as computed using the value" do
      visualizer.mark_value([1, 0], 5)
      expect(visualizer.value_at(1,0)).to eq(5)
    end

    it "can mark a square as returned using an X"
  end

end
