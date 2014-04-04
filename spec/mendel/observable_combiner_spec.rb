require_relative "../spec_helper"
require "mendel/observable_combiner"

describe Mendel::ObservableCombiner do

  let(:combiner_class) {
    Class.new(Mendel::ObservableCombiner) do
      def score_combination(items)
        items.reduce(0) { |sum, item| sum += item }
      end
    end
  }
  let(:combiner)       { combiner_class.new(list1, list2) }
  let(:list1)          { [1.0, 2.0, 3.0] }
  let(:list2)          { [1.1, 2.1, 3.1] }

  describe "notification of events" do

    describe "when a combination is returned" do

      it "notifies that the combo's children have been scored and that the combo has been returned" do
        # 2 times because with two lists there are two child coordinates
        expect(combiner).to receive(:notify).exactly(2).times.with(
          :scored, a_hash_including(
            'coordinates' => an_instance_of(Array),
            'score'       => a_kind_of(Numeric)
          )
        )
        expect(combiner).to receive(:notify).exactly(1).times.with(
          :returned, a_hash_including(
            'coordinates' => an_instance_of(Array),
            'score'       => a_kind_of(Numeric)
          )
        )
        combiner.take(1)
      end

    end

  end

end
