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
        loop do
          item = pop
          break if item.nil?
          items << item
        end
      }
    end

    def dump_json
      JSON.dump(dump)
    end

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
