require_relative "spec_helper"
require_relative "../lib/mendel/combiner"
require_relative "fixtures/example_input"

describe Mendel::Combiner do

  # list1: {name: 'Jimmy', age: 10}, {name: 'Roger', age: 12}
  # list2: {name: 'Susan', age: 8}, {name: 'Lisa', age: 14}
  #
  # combinations:
  #   [
  #     # No particular order...
  #     {items: [{name: 'Jimmy', age: 10}, {name: 'Susan', age: 8}], score: 18}
  #     {items: [{name: 'Jimmy', age: 10}, {name: 'Lisa', age: 14}], score: 24}
  #     ...
  #   ]

  let(:combiner_class) {
    Class.new do
      def score_combination(*items)
        items.reduce(0) { |sum, item| sum += item['age'].to_i }
      end
    end
    Mendel::Combiner
  }

  let(:combiner) {
    Mendel::Combiner.new(list1, list2, PriorityQueue.new).tap { |c|
      # def c.score_combinations(*items)
      #   items.reduce(0) { |sum, item| sum += item['age'].to_i }
      # end
    }
  }

  let(:list1) { EXAMPLE_INPUT[:incrementing_integers] }

  it "makes coords rightly" do
    c = Mendel::Combiner.new(%w[a b], %w[c d], PriorityQueue.new)
    expect(c.increments_from([0,0])).to eq([[1,0], [0,1]])

    c = Mendel::Combiner.new(%w[a b], %w[c d], %w[e f], PriorityQueue.new)
    expect(c.increments_from([0,0,0])).to eq([[1,0,0],[0,1,0],[0,0,1]])
  end

  describe "when both lists increment smoothly" do
    let(:list2) { EXAMPLE_INPUT[:incrementing_decimals] }

    it "gets the top N results" do
      require_relative "fixtures/example_output/inc_integers_w_inc_decimals"
      expect(combiner.results).to eq($inc_integers_w_inc_decimals)
    end

  end

  describe "when the second list has repeats" do
    let(:list2) { EXAMPLE_INPUT[:repeats] }

    it "gets the top N results" do
      pending "See if it can be made to handle this"
      require_relative "fixtures/example_output/inc_integers_w_repeats"
      expect(combiner.results).to eq($inc_integers_w_repeats)
    end

  end

  describe "when the second list has skips" do
    let(:list2) { EXAMPLE_INPUT[:skips] }

    it "gets the top N results" do
      pending "See if it can be made to handle this"
      require_relative "fixtures/example_output/inc_integers_w_skips"
      expect(combiner.results).to eq($inc_integers_w_skips)
    end

  end

  describe "when the second list has repeats AND skips" do
    let(:list2) { EXAMPLE_INPUT[:repeats_and_skips] }

    it "gets the top N results" do
      pending "See if it can be made to handle this"
      require_relative "fixtures/example_output/inc_integers_w_repeats_and_skips"
      expect(combiner.results).to eq($inc_integers_w_repeats_and_skips)
    end

  end

end
