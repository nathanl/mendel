require "priority_queue" # gem
require 'json'

# Wrapper to allow swapping implementations
module Mendel
  class MinPriorityQueue

    def initialize
      self.wrapped_queue = PriorityQueue.new
    end

    def push(item, priority)
      wrapped_queue.push(item, priority)
    end

    def pop
      wrapped_queue.delete_min
    end

    def length
      wrapped_queue.length
    end

    def dump
      [].tap {|items|
        items << pop while length > 0
      }
    end

    def dump_json
      JSON.dump(dump)
    end

    # TODO - make the load methods class methods
    def load(items)
      items.each do |item|
        push(*item)
      end
    end

    def load_json(json)
      load(JSON.parse(json))
    end

    private
    attr_accessor :wrapped_queue
  end
end
