require_relative "../spec_helper"
require "mendel/min_priority_queue"

describe Mendel::MinPriorityQueue do

  let(:queue) { described_class.new }

  describe "basic functionality" do

    it "can add an item"

    it "can pop an item of the lowest priority"

    it "can report its length"

  end

  describe "dumping and loading" do

    describe "dumping" do

      let(:queue) {
        described_class.new.tap { |q|
          q.push('c', 3)
          q.push('a', 1)
          q.push('b', 2)
        }
      }

      it "can dump its contents as an array" do
        expect(queue.dump).to eq([['a', 1], ['b', 2], ['c', 3]])
      end

      it "can dump its contents as json" do
        expect(queue.dump_json).to eq("[[\"a\",1],[\"b\",2],[\"c\",3]]")
      end

    end

    describe "loading" do

      it "can load its contents from an array" do
        queue.load([['a', 1], ['b', 2], ['c', 3]])
        expect(queue.length).to eq(3)
        expect(queue.pop).to eq(['a', 1])
      end

      it "can load its contents from JSON" do
        queue.load_json("[[\"a\",1],[\"b\",2],[\"c\",3]]")
        expect(queue.length).to eq(3)
        expect(queue.pop).to eq(['a', 1])
      end

    end

  end
  
end
