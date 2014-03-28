require_relative "../../spec_helper"
require "mendel/visualizers/ascii"

describe Mendel::Visualizers::ASCII do

  let(:klass) { described_class }

  describe "after initialization" do

    let(:list1)      { (1..10).to_a              }
    let(:list2)      { (1..10).map {|i| i + 0.1} }
    let(:visualizer) { klass.new(list1, list2)   }

    describe "output" do

      it "shows an empty grid when initialized" do
        pending "First implement base"
        expect(visualizer.output).to eq(
          <<-WOO
          00010


          00009


          00008


          00007


          00006


          00005


          00004


          00003


          00002


          00001
               0001.1  0002.1  0003.1  0004.1  0005.1  0006.1  0007.1  0008.1  0009.1  0010.1
          WOO
        )
      end

    end

  end

end

