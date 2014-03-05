require_relative "spec_helper"
require_relative "../lib/mendel/combiner"
require_relative "fixtures/example_input"

describe Mendel::Combiner do

  let(:combiner_class) { described_class }
  let(:combiner)       { combiner_class.new(list1, list2) }

  let(:list1)          { EXAMPLE_INPUT[:incrementing_integers] }
  let(:all_results)    { combiner.results }

  describe "when both lists increment smoothly" do
    let(:list2) { EXAMPLE_INPUT[:incrementing_decimals] }

    it "has a complete result set that is ordered correctly" do
      require_relative "fixtures/example_output/inc_integers_w_inc_decimals"
      expect(all_results).to be_sorted_like($inc_integers_w_inc_decimals)
    end

  end

  describe "when the second list has repeats" do
    let(:list2) { EXAMPLE_INPUT[:repeats] }

    it "has a complete result set that is ordered correctly" do
      require_relative "fixtures/example_output/inc_integers_w_repeats"
      expect(all_results).to be_sorted_like($inc_integers_w_repeats)
    end

  end

  describe "when the second list has skips" do
    let(:list2) { EXAMPLE_INPUT[:skips] }

    it "has a complete result set that is ordered correctly" do
      require_relative "fixtures/example_output/inc_integers_w_skips"
      expect(all_results).to be_sorted_like($inc_integers_w_skips)
    end

  end

  describe "when the second list has repeats AND skips" do
    let(:list2) { EXAMPLE_INPUT[:repeats_and_skips] }

    it "has a complete result set that is ordered correctly" do
      require_relative "fixtures/example_output/inc_integers_w_repeats_and_skips"
      expect(all_results).to be_sorted_like($inc_integers_w_repeats_and_skips)
    end

  end

  describe "when the lists are different lengths" do
    let(:list2) { EXAMPLE_INPUT[:short_list] }

    it "has a complete result set that is ordered correctly" do
      require_relative "fixtures/example_output/different_lengths"
      expect(all_results).to be_sorted_like($different_lengths)
    end

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

    it "has a complete result set that is ordered correctly" do
      expect(all_results).to be_sorted_like(sorted_combos)
    end
  end

end
