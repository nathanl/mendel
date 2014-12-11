require_relative "../../spec_helper"
require "mendel"
require "mendel/observable_combiner"
require "mendel/visualizers/ascii"

describe Mendel::Visualizers::ASCII do

  let(:klass) { described_class }
  let(:combiner_class) {
    Class.new(Mendel::ObservableCombiner) do
      def score_combination(items)
        items.reduce(0) { |sum, item| sum += item }
      end
    end
  }

  let(:combiner)   { combiner_class.new(list1, list2) }
  let(:list1)      { (1..10).to_a }
  let(:list2)      { (1..10).map { |i| i + 0.1} }
  let(:klass)      { described_class }
  let!(:visualizer) { klass.new(combiner) }

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

      describe "grid points" do

        it "represents :unscored as a blank 8 spaces wide" do
          expect(visualizer.grid_point_for(:unscored)).to eq('        ')
        end

        it "represents :scored as a blue number" do
          expect(visualizer.grid_point_for(:scored, 5)).to eq('       5'.blue)
        end

        it "represents :returned as a green number" do
          expect(visualizer.grid_point_for(:returned, 873)).to eq('     873'.green)
        end

      end

      describe "output" do

        let(:empty_grid) {
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
        }

        it "shows an empty grid when initialized" do
          expect(visualizer.output).to eq(empty_grid)
        end

        it "shows something else after enumerating" do
          combiner.take(3)
          expect(visualizer.output).not_to eq(empty_grid)
        end

      end

    end

  end

end

