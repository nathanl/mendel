require "mendel/combiner"

module Mendel
  class ObservableCombiner
    include Mendel::Combiner
    include Observable

    def queueable_item_for(coordinates)
      super.tap {|combo| notify(:scored, combo) }
    end

    def pop_queue
      super.tap { |pair|
        return if pair.nil?
        coords = pair[0].fetch('coordinates')
        notify(:returned, {'coordinates' => coords, 'score' => pair[1]}) unless pair.nil?
      }
    end

    def notify(*args)
      changed && notify_observers(*args)
    end
  end
end
