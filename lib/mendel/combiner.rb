require "mendel/version"

module Mendel
  require_relative 'smarandache'

  class Combiner
    attr_accessor :list1, :list2

    def initialize(list1, list2)
      self.list1   = list1
      self.list2   = list2
    end

    def results
      results = []
      enum1 = Smarandache::Decrescendo.new(list1)
      enum2 = Smarandache::Crescendo.new(list2)
      loop do
        a = enum1.next
        b = enum2.next
        results << [a, b, a + b]
      end

      results
    rescue StopIteration
      return results
    end

  end
end
