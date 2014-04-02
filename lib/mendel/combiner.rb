require "mendel/version"
require "mendel/min_priority_queue"
require "observer"
require "set"

module Mendel

  module Combiner
    include Enumerable
    include Observable

    attr_accessor :lists, :priority_queue

    def self.included(target)
      target.extend(ClassMethods)
    end

    def initialize(*lists)
      self.lists          = lists
      self.priority_queue = MinPriorityQueue.new
      queue_combo_at(lists.map {0} )
    end

    def each
      return self.to_enum unless block_given?
      loop do
        combo = next_combination
        break if combo == :none
        yield combo
      end
    end

    def dump
      {INPUT => lists, SEEN => seen_set.to_a, QUEUED => priority_queue.dump }
    end

    def dump_json
      JSON.dump(dump)
    end

    def queue_length
      priority_queue.length
    end

    def score_combination(items)
      raise NotImplementedError,
        "Including class must define. Take N items (one from each list) and produce a combined score"
    end

    private

    def seen_set
      @seen ||= Set.new
    end

    def seen_set=(set)
      @seen = set
    end

    def next_combination
      item = priority_queue.pop
      return :none if item.nil?
      combo, score = item
      children_coordinates = next_steps_from(combo.fetch(COORDINATES))
      children_coordinates.each {|cc| queue_combo_at(cc) }
      notify(:returned, combo)
      [combo.fetch(ITEMS), score].flatten
    end

    def queue_combo_at(coordinates)
      return if seen_set.include?(coordinates)
      seen_set << coordinates
      combo = combo_at(coordinates)
      priority_queue.push(combo, combo.fetch(SCORE))
    end

    def combo_at(coordinates)
      return unless valid_for_lists?(coordinates, lists)
      items = lists.each_with_index.map {|list, i| list[coordinates[i]] }
      {ITEMS => items, COORDINATES => coordinates, SCORE => score_combination(items)}.tap {|combo|
        notify(:scored, combo)
      }
    end

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

    def notify(*args)
      changed && notify_observers(*args)
    end

    # To keep from allocating so many strings
    COORDINATES = 'coordinates'.freeze
    INPUT       = 'input'.freeze
    ITEMS       = 'items'.freeze
    QUEUED      = 'queued'.freeze
    SCORE       = 'score'.freeze
    SEEN        = 'seen'.freeze

    module ClassMethods
      def load(data)
        instance = new(*data.fetch(INPUT))
        instance.instance_eval {
          self.seen_set       = Set.new(data.fetch(SEEN))
          self.priority_queue = MinPriorityQueue.new.tap {|q| q.load(data.fetch(QUEUED))}
        }
        instance
      end

      def load_json(json)
        self.load(JSON.parse(json))
      end
    end
  end
end
