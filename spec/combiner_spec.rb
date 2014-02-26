require_relative "spec_helper"
require_relative "../lib/mendel/combiner"
require_relative "fixtures/example_input"

describe Mendel::Combiner do

  let(:combiner) { Mendel::Combiner.new(list1, list2) }
  let(:list1) { EXAMPLE_INPUT[:incrementing_integers] }

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
