require_relative "spec_helper"
require_relative "../lib/mendel/combiner"
require_relative "fixtures/example_input"

describe Mendel::Combiner do

  describe "producing correct output" do

    let(:combiner_class) { described_class }
    let(:combiner)       { combiner_class.new(list1, list2) }

    let(:list1)          { EXAMPLE_INPUT[:incrementing_integers] }
    let(:all_results)    { combiner.to_a }

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

  describe "enumeration" do

    let(:combiner) { described_class.new([1,2], [1.1, 2.1]) }

    it "supports external enumeration" do
      enum = combiner.each
      expect(enum.next).to eq([1, 1.1, 2.1])
      expect(enum.next).to eq([2, 1.1, 3.1])
    end

    it "supports internal enumeration" do
      combos = []
      combiner.each do |combo|
        combos << combo
      end
      expect(combos.length).to eq(4)
    end

    it "is Enumerable" do
      expect(combiner).to be_a(Enumerable)
    end

    it "supports enumerable operations" do
      expect(combiner.map {|c| c[-1] }).to eq([2.1, 3.1, 3.1, 4.1])
    end

    describe "laziness" do

      it "supports lazy enumeration" do
        outs = []
        m = combiner.each.lazy.map { outs << 'first map' }.map { outs << 'second map' }
        2.times { m.next }
        expect(outs).to eq(['first map', 'second map', 'first map', 'second map'])
      end

      it "doesn't sneakily build all combinations just to return one" do
        e = combiner.each
        e.next
        # I'M SORRY MR OBJECT, PLEASE FORGIVE THE INTRUSION
        expect(combiner.send(:combinations).length).to eq(1)
      end

    end

  end

  describe "dumping and loading state" do

    let(:combiner) { described_class.new([1,2,3], [1.1, 2.1, 3.1]) }

    context "when it has produced some combinations" do

      before :each do
        enum = combiner.each
        2.times { enum.next }
      end

      # NOTE
      # state exists in:
      # - lists passed in
      # - seen_set (coordinates tried)
      # - items in priority_queue (previously built but not returned)
      # - combinations (previously returned)

      it "can dump its state"

    end

    context "when state has been dumped somewhere" do

      it "can load state"

      it "can begin producing combinations again from that point"

    end

  end

end
