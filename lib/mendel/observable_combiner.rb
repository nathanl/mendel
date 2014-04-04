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
        notify(:returned, {'coordinates' => pair[0], 'score' => pair[1]}) unless pair.nil?
      }
    end

    def notify(*args)
      changed && notify_observers(*args)
    end
  end
end
