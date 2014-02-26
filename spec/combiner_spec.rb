require_relative "spec_helper"
require_relative "../lib/mendel/combiner"
require_relative "fixtures/example_input"

describe Mendel::Combiner do

  let(:combiner_class) { described_class }
  let(:combiner) { Mendel::Combiner.new(list1, list2, PriorityQueue.new) }

  let(:list1) { EXAMPLE_INPUT[:incrementing_integers] }
  let(:results) {combiner.results}

  describe "when both lists increment smoothly" do
    let(:list2) { EXAMPLE_INPUT[:incrementing_decimals] }

    it "gets the top N results" do
      require_relative "fixtures/example_output/inc_integers_w_inc_decimals"
      expect(results).to be_sorted_like($inc_integers_w_inc_decimals)
    end

  end

  describe "when the second list has repeats" do
    let(:list2) { EXAMPLE_INPUT[:repeats] }

    it "gets the top N results" do
      require_relative "fixtures/example_output/inc_integers_w_repeats"
      the_end = 25
      expect(combiner.results[0..the_end]).to be_sorted_like($inc_integers_w_repeats[0..the_end])
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

  describe "when the lists are different lengths" do

  end

  context "with lists of other items" do


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
    #
    # let(:combiner_class) {
    # Class.new(Mendel::Combiner) do
    #   def score_combination(*items)
    #     items.reduce(0) { |sum, item| sum += item['age'].to_i }
    #   end
    # end
    # }
  end

end
