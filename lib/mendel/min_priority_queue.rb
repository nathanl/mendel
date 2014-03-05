require "priority_queue" # gem

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

    private
    attr_accessor :wrapped_queue
  end
end
