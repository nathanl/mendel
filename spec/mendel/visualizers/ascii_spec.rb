require_relative "../../spec_helper"
require "mendel"
require "mendel/visualizers/ascii"

describe Mendel::Visualizers::ASCII do

  let(:klass) { described_class }
  let(:combiner_class) {
    Class.new do
      include Mendel::Combiner
      def score_combination(items)
        items.reduce(0) { |sum, item| sum += item }
      end
    end
  }

  let(:combiner)   { combiner_class.new(list1, list2) }
  let(:list1)      { (1..10).to_a }
  let(:list2)      { (1..10).map { |i| i + 0.1} }
  let(:klass)      { described_class }
  let(:visualizer) { klass.new(combiner) }

  describe "after initialization" do

    describe "output" do

      describe "axis labels" do

        it "converts the list item to a string" do
          item = '1'
          expect(item).to receive(:to_s).and_call_original
          visualizer.axis_label_for(item)
        end

        it "pads the output to be 8 characters wide" do
          item = 1
          expect(visualizer.axis_label_for(item)).to eq(
            '       1'
          )
        end

        it "limits the output to 8 characters" do
          item = '0123456789'
          expect(visualizer.axis_label_for(item)).to eq(
            '01234567'
          )
        end

      end

      it "shows an empty grid when initialized" do
        expect(visualizer.output).to eq(
          <<-WOO
      10


       9


       8


       7


       6


       5


       4


       3


       2


       1
             1.1       2.1       3.1       4.1       5.1       6.1       7.1       8.1       9.1      10.1
          WOO
        )
      end

    end

  end

end

