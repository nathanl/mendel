require "mendel/version"
require "mendel/min_priority_queue"
require "set"

module Mendel

  class Combiner
    include Enumerable

    attr_accessor :lists, :priority_queue

    def initialize(*lists)
      self.lists          = lists
      self.combinations   = []
      self.priority_queue = MinPriorityQueue.new
      add_coords(lists.map {0} )
    end

    def each
      return self.to_enum unless block_given?
      combinations.each { |c| yield c}
      loop do
        combo = next_combination
        break if combo == :none
        yield combo
      end
    end

    private

    attr_accessor :combinations

    def seen_set
      @seen ||= Set.new
    end

    def next_combination
      combo = priority_queue.pop
      return :none if combo.nil?
      combo = combo[0]
      children_coordinates = next_steps_from(combo.fetch(:coordinates))
      children_coordinates.each {|co| add_coords(co) }
      [combo.fetch(:items), combo.fetch(:score)].flatten.tap { |combination|
        combinations << combination
      }
    end

    def add_coords(coordinates)
      return if seen_set.include?(coordinates)
      seen_set << coordinates
      combo = combo_at(coordinates)
      priority_queue.push(combo, combo[:score])
    end

    def combo_at(coordinates)
      return unless valid_for_lists?(coordinates, lists)
      items = lists.each_with_index.map {|list, i| list[coordinates[i]] }
      {items: items, coordinates: coordinates, score: score_combination(items)}
    end

    # Override on instance if you like
    def score_combination(items)
      items.reduce(0) { |sum, item| sum += item }
    end

    # def results
    # rescue StopIteration
    #   return results
    # end

    # Increments which are valid for instance's lists
    def next_steps_from(coordinates)
      increments_from(coordinates).select { |coords| valid_for_lists?(coords, lists) }
    end

    # All possible coordinates which are one greater than the given
    # coords in a single direction.
    # Eg:
    # next_steps_from([0,0]) 
    #   #=> [[0,1], [1, 0]]
    # next_steps_from([10,5,7])
    #   => [[11, 5, 7], [10, 6, 7], [10, 5, 8]]
    def increments_from(coordinates)
      coordinates.length.times.map { |i| coordinates.dup.tap { |c| c[i] += 1} }
    end

    # Do the coordinates represent a valid location given these lists?
    # Eg:
    #   valid_for_lists?([0,1], [['thundercats', 'voltron'], ['hi', 'ho']])
    #     #=> true - represents ['thundercats', 'ho']
    #   valid_for_lists?([0,2], [['thundercats', 'voltron'], ['hi', 'ho']])
    #     #=> false - first list has an index 0, but second list has no index 2
    #   valid_for_lists?([0,2,0], [['thundercats', 'voltron'], ['hi', 'ho']])
    #     #=> false - there are only two lists
    def valid_for_lists?(coords, lists)
      # Must give exactly one index per list
      return false unless coords.length == lists.length
      coords.each_with_index.all? { |value, index| valid_index_in?(lists[index], value) }
    end

    # Eg:
    #   valid_index_in?(['hi', 'ho'],  1) #=> true
    #   valid_index_in?(['hi', 'ho'],  2) #=> false
    #   valid_index_in?(['hi', 'ho'], -2) #=> true
    #   valid_index_in?(['hi', 'ho'], -3) #=> true
    def valid_index_in?(array, index)
      index <= (array.length - 1) && index >= (0 - array.length)
    end

  end
end
