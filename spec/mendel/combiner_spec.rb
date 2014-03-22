require_relative "../spec_helper"
require "mendel/combiner"
require "fixtures/example_input"

describe Mendel::Combiner do

  describe "producing correct output" do

    let(:combiner_class) { described_class }
    let(:combiner)       { combiner_class.new(list1, list2) }

    let(:list1)          { EXAMPLE_INPUT[:incrementing_integers] }
    let(:all_results)    { combiner.to_a }

    describe "when both lists increment smoothly" do
      let(:list2) { EXAMPLE_INPUT[:incrementing_decimals] }

      it "has a complete result set that is ordered correctly" do
        require "fixtures/example_output/inc_integers_w_inc_decimals"
        expect(all_results).to be_sorted_like($inc_integers_w_inc_decimals)
      end

    end

    describe "when the second list has repeats" do
      let(:list2) { EXAMPLE_INPUT[:repeats] }

      it "has a complete result set that is ordered correctly" do
        require "fixtures/example_output/inc_integers_w_repeats"
        expect(all_results).to be_sorted_like($inc_integers_w_repeats)
      end

    end

    describe "when the second list has skips" do
      let(:list2) { EXAMPLE_INPUT[:skips] }

      it "has a complete result set that is ordered correctly" do
        require "fixtures/example_output/inc_integers_w_skips"
        expect(all_results).to be_sorted_like($inc_integers_w_skips)
      end

    end

    describe "when the second list has repeats AND skips" do
      let(:list2) { EXAMPLE_INPUT[:repeats_and_skips] }

      it "has a complete result set that is ordered correctly" do
        require "fixtures/example_output/inc_integers_w_repeats_and_skips"
        expect(all_results).to be_sorted_like($inc_integers_w_repeats_and_skips)
      end

    end

    describe "when the lists are different lengths" do
      let(:list2) { EXAMPLE_INPUT[:short_list] }

      it "has a complete result set that is ordered correctly" do
        require "fixtures/example_output/different_lengths"
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

    it "is Enumerable" do
      expect(combiner).to be_a(Enumerable)
    end

    it "supports normal enumerable operations" do
      expect(combiner.take(3).map {|c| c[-1] }).to eq([2.1, 3.1, 3.1])
    end

  end

  describe "dumping and loading state" do

    let(:list1)    { [1,2,3] }
    let(:list2)    { [1.1, 2.1, 3.1] }
    let(:combiner) { described_class.new(list1, list2) }

    context "when it has produced some combinations" do

      before :each do
        combiner.take(3)
      end

      let(:dumped) {
        {
          'input' => [list1, list2], 'seen' => [[0, 0], [1, 0], [0, 1], [2, 0], [1, 1], [0, 2]],
          'queued' => [
            [{'items' =>[2, 2.1], 'coordinates' =>[1, 1], 'score' => 4.1}, 4.1], 
            [{'items' =>[3, 1.1], 'coordinates' =>[2, 0], 'score' => 4.1}, 4.1],
            [{'items' =>[1, 3.1], 'coordinates' =>[0, 2], 'score' => 4.1}, 4.1],
          ]
        }
      }

      it "can dump its state" do
        expect(combiner.dump).to eq(dumped)
      end

      it "can dump its state as JSON" do
        expect(combiner.dump_json).to eq(JSON.dump(dumped))
      end

      context "when state has been dumped somewhere" do

        context "as a hash" do

          let!(:dumped_data) { combiner.dump }

          it "can load state" do
            expect(Mendel::Combiner.load(dumped_data)).to be_a(Mendel::Combiner)
          end

          it "can begin producing combinations again from that point" do
            combiner = Mendel::Combiner.load(dumped_data)
            expect(combiner.take(3)).to be_sorted_like([[2, 2.1, 4.1], [3, 1.1, 4.1], [1, 3.1, 4.1]])
          end

        end

        context "as json" do

          let!(:dumped_json) { combiner.dump_json }

          it "can load state" do
            expect(Mendel::Combiner.load_json(dumped_json)).to be_a(Mendel::Combiner)
          end

          it "can begin producing combinations again from that point" do
            combiner = Mendel::Combiner.load_json(dumped_json)
            expect(combiner.take(3)).to be_sorted_like([[2, 2.1, 4.1], [3, 1.1, 4.1], [1, 3.1, 4.1]])
          end

        end

      end

    end

  end

end
