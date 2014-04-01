module Mendel
  module Visualizers
    class Base
      attr_accessor :list1, :list2
      attr_reader :grid

      def self.max_list_length
        10 # To be decided
      end

      def initialize(combiner)
        combiner.add_observer(self)
        lists = combiner.lists
        raise InvalidListCount, "Can only graph in 2 dimensions" unless lists.length == 2
        raise ListsTooLarge,    "Need to fit on screen"          if lists.any? {|l| l.length > self.class.max_list_length }
        @list1, @list2 = lists
        @grid = Array.new(list1.size) { Array.new(list2.size, :unscored) }
      end

      def update(event, combo)
        puts combo.fetch('coordinates')
      end

      private

      InvalidListCount = Class.new(StandardError)
      ListsTooLarge    = Class.new(StandardError)
    end
  end
end
