require_relative "../spec_helper"
require "mendel/combiner"
require "fixtures/example_input"
require "support/foosball_team"

describe Mendel::Combiner do

  let(:combiner_class) {
    Class.new do
      include Mendel::Combiner
      def score_combination(items)
        items.reduce(0) { |sum, item| sum += item }
      end
    end

  }
  let(:combiner)       { combiner_class.new(list1, list2) }
  let(:list1)          { [1.0, 2.0, 3.0] }
  let(:list2)          { [1.1, 2.1, 3.1] }

  describe "requiring the including class to define `score_combination`" do

    let(:combiner_class) {
      Class.new do
        include Mendel::Combiner
      end
    }

    it "raises NotImplementedError otherwise" do
      expect{combiner.take(1)}.to raise_error(NotImplementedError)
    end

  end

  describe "producing correct output" do

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

    context "when there are more than 2 lists" do

      let(:list3) { [1.2, 2.2, 3.2] }
      let(:list4) { [1.3, 2.3, 3.3] }

      let(:combiner) { combiner_class.new(list1, list2, list3, list4) }

      it "can produce valid combinations" do
        expect(combiner.first).to eq([[1.0, 1.1, 1.2, 1.3], 4.6])
      end

    end

    context "when given lists of non-numeric items" do

      let(:list1) { [{name: 'Jimmy', age: 10}, {name: 'Susan', age: 12}] }
      let(:list2) { [{name: 'Roger', age: 8},  {name: 'Carla',  age: 14}] }
      let(:sorted_combos) {
        combos = []
        list1.each do |player_1|
          list2.each do |player_2|
            combos << [
              FoosballTeam.new(player_1, player_2),
              (player_1[:age] + player_2[:age]) / 2.0
            ]
          end
        end
        combos.sort_by {|c| c.last}
      }

      context "when the combiner class has custom combination and scoring methods" do

        let(:combiner_class) {
          Class.new do
            include Mendel::Combiner

            def build_combination(items)
              FoosballTeam.new(*items)
            end

            def score_combination(combination)
              combination.average_age
            end
          end
        }

        it "has a complete result set that is ordered correctly" do
          expect(all_results).to be_sorted_like(sorted_combos)
        end

      end

    end

    context "when the input lists are not sorted in ascending order" do

      let(:list1) { EXAMPLE_INPUT[:incrementing_integers].reverse }
      let(:list2) { EXAMPLE_INPUT[:incrementing_decimals].shuffle }

      it "does not produce correct output" do
        require "fixtures/example_output/inc_integers_w_inc_decimals"
        expect(all_results).not_to be_sorted_like($inc_integers_w_inc_decimals)
      end

    end

  end

  describe "enumeration" do

    it "is Enumerable" do
      expect(combiner).to be_a(Enumerable)
    end

    it "supports normal enumerable operations" do
      expect(combiner.take(3).map {|c| c[-1] }).to eq([2.1, 3.1, 3.1])
    end

  end

  describe "dumping and loading state" do

    context "when it has produced some combinations" do

      before :each do
        combiner.take(3)
      end

      let(:dumped) {
        {
          'input' => [list1, list2], 'seen' => [[0, 0], [1, 0], [0, 1], [2, 0], [1, 1], [0, 2]],
          'queued' => [
            [{'combo'=>[2.0, 2.1], "coordinates"=>[1, 1]}, 4.1],
            [{"combo"=>[3.0, 1.1], "coordinates"=>[2, 0]}, 4.1],
            [{"combo"=>[1.0, 3.1], "coordinates"=>[0, 2]}, 4.1],
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
            expect(combiner_class.load(dumped_data)).to be_a(combiner_class)
          end

          it "can begin producing combinations again from that point" do
            combiner = combiner_class.load(dumped_data)
            expect(combiner.take(3)).to be_sorted_like([[[2.0, 2.1], 4.1], [[3.0, 1.1], 4.1], [[1.0, 3.1], 4.1]])
          end

        end

        context "as json" do

          let!(:dumped_json) { combiner.dump_json }

          it "can load state" do
            expect(combiner_class.load_json(dumped_json)).to be_a(combiner_class)
          end

          it "can begin producing combinations again from that point" do
            combiner = combiner_class.load_json(dumped_json)
            expect(combiner.take(3)).to be_sorted_like([[[2.0, 2.1], 4.1], [[3.0, 1.1], 4.1], [[1.0, 3.1], 4.1]])
          end

        end

      end

    end

  end

  describe "other methods" do

    it "can return its queue length" do
      expect(combiner.queue_length).to eq(1) # item at 0,0
      combiner.take(1)
      expect(combiner.queue_length).to eq(2) # queued its children
    end

  end

end
