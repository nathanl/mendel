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

    describe "maintaining a list of changes" do

      it "can be told that a coordinate has been computed"

      it "can be told that a coordinate's combination has been returned"

    end

    describe "producing frames of output" do

      it "produces frames of output using the recorded changes"

      it "allows enumeration of the frames"

    end

  end

end
