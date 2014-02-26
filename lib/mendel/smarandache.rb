# http://mathworld.wolfram.com/SmarandacheSequences.html
module Smarandache
  class Base
    attr_accessor :arr
    def initialize(arr)
      raise ArgumentError, "empty array" if arr.empty?
      self.arr        = arr
      self.startpoint = 0
      self.endpoint   = 0
      self.pointer    = 0
    end

    def next
      return produce_result if pointer_valid?

      if can_slide_endpoint?
        slide_endpoint
        start_new_cycle
        produce_result
      elsif can_slide_startpoint?
        slide_startpoint
        start_new_cycle
        produce_result
      else
        raise StopIteration
      end
    end
    
    def produce_result
      arr[pointer].tap { |v|
        slide_pointer
      }
    end

    def valid_index?(index)
      index >= 0 && index < arr.length
    end

    def pointer_valid?
      pointer >= startpoint && pointer <= endpoint
    end

    def can_slide_endpoint?
      valid_index?(endpoint + 1)
    end

    def slide_endpoint
      self.endpoint = endpoint + 1
    end

    def can_slide_startpoint?
      valid_index?(startpoint + 1)
    end

    def slide_startpoint
      self.startpoint = startpoint + 1
    end

    private
    attr_accessor :startpoint, :endpoint, :pointer

  end

  class Decrescendo < Base
    def slide_pointer
      self.pointer = pointer - 1
    end

    def start_new_cycle
      self.pointer = endpoint
    end
  end

  class Crescendo < Base
    def slide_pointer
      self.pointer = pointer + 1
    end

    def start_new_cycle
      self.pointer = startpoint
    end
  end

end
