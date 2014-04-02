require_relative "../../spec_helper"
require "mendel"
require "mendel/visualizers/base"

describe Mendel::Visualizers::Base do

  let(:klass) { described_class }
  let(:combiner_class) {
    Class.new do
      include Mendel::Combiner
      def score_combination(items)
        items.reduce(0) { |sum, item| sum += item }
      end
    end
  }

  let(:combiner) { combiner_class.new(list1, list2) }
  let(:list1)      { (1..10).to_a              }
  let(:list2)      { (1..10).map {|i| i + 0.1} }

  describe "initialization" do

    it "adds itself to the observers of the combiner" do
      expect(combiner).to receive(:add_observer)
      klass.new(combiner)
    end

    it "requires the combiner to have exactly 2 lists" do
      expect{klass.new(combiner)}.not_to raise_error
      expect{klass.new(combiner_class.new([1], [2], [3]))}.to raise_error(klass.const_get('InvalidListCount'))
      expect{klass.new(combiner_class.new([1]))}.to raise_error(klass.const_get('InvalidListCount'))
    end

    it "limits list length" do
      over = klass.max_list_length + 10
      expect{klass.new(combiner_class.new([1], (1..over).to_a))}.to raise_error(klass.const_get('ListsTooLarge'))
    end

  end

  describe "after initialization" do

    let!(:visualizer) { klass.new(combiner) }

    describe "keeping a grid of state" do

      it "starts everything as unscored" do
        expect(visualizer.grid).to eq(
          Array.new(list2.size, Array.new(list1.size, :unscored))
        )
      end

      describe "handling notifications when a combination is returned" do

        before :each do
          combiner.take(1)
        end

        it "remembers which item was returned" do
          expect(visualizer.grid[0][0]).to eq(:returned)
        end

        it "remembers which items were scored" do
          expect(visualizer.grid[1][0]).to eq(:scored)
          expect(visualizer.grid[0][1]).to eq(:scored)
        end

      end

    end

  end

end
