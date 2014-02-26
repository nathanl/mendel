require_relative "spec_helper"
require_relative "../lib/mendel/combiner"
require_relative "fixtures/example_input"

describe Mendel::Combiner do

  let(:combiner_class) { described_class }
  let(:combiner)       { combiner_class.new(list1, list2, PriorityQueue.new) }

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
      pending "getting our priority queue to dedupe?"
      require_relative "fixtures/example_output/inc_integers_w_repeats"
      puts "lengths are #{combiner.results.length} and #{$inc_integers_w_repeats.length}"
      the_end = 25
      expect(combiner.results[0..the_end]).to be_sorted_like($inc_integers_w_repeats[0..the_end])
    end

  end

  describe "when the second list has skips" do
    let(:list2) { EXAMPLE_INPUT[:skips] }

    it "gets the top N results" do
      require_relative "fixtures/example_output/inc_integers_w_skips"
      expect(combiner.results).to be_sorted_like($inc_integers_w_skips)
    end

  end

  describe "when the second list has repeats AND skips" do
    let(:list2) { EXAMPLE_INPUT[:repeats_and_skips] }

    it "gets the top N results" do
      pending "getting our priority queue to dedupe?"
      require_relative "fixtures/example_output/inc_integers_w_repeats_and_skips"
      expect(combiner.results).to be_sorted_like($inc_integers_w_repeats_and_skips)
    end

  end

  describe "when the lists are different lengths" do

  end

  context "with lists of other items" do

    let(:list1) { [{name: 'Jimmy', age: 10}, {name: 'Susan', age: 12}] }
    let(:list2) { [{name: 'Roger', age: 8},  {name: 'Carla',  age: 14}] }
    let(:sorted_combos) {
      combos = []
      list1.each do |l1|
        list2.each do |l2|
          combos << [l1, l2, l1[:age] + l2[:age]]
        end
      end
      combos.sort_by {|c| c.last}
    }

    let(:combiner_class) {
      Class.new(Mendel::Combiner) do
        def score_combination(items)
          items.reduce(0) { |sum, item| 
            sum += item[:age].to_i 
          }
        end
      end
    }

    it "does fine" do
      expect(combiner.results).to be_sorted_like(sorted_combos)
    end
  end

end
