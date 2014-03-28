module Mendel
  module Visualizers
    class Base
      attr_accessor :list1, :list2

      def self.max_list_length
        10 # To be decided
      end

      def initialize(*lists)
        raise InvalidListCount, "Can only graph in 2 dimensions" unless lists.length == 2
        raise ListsTooLarge,    "Need to fit on screen"          if lists.any? {|l| l.length > self.class.max_list_length }
        @list1, @list2 = lists
        build_coords
      end

      def mark_value(coords, value)
        x, y = coords
        @coords[x][y] = value
      end

      def value_at(x, y)
        @coords[x][y]
      end

      def output
      end

      private

      def build_coords
        @coords = {}
        list1.each_with_index do |thingy, i| 
          @coords[i] = {}
          list2.each_with_index do |whatever, k|
            @coords[i][k] = nil
          end
        end
      end

      InvalidListCount = Class.new(StandardError)
      ListsTooLarge    = Class.new(StandardError)
    end
  end
end
