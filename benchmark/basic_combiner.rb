class BasicCombiner
  include Mendel::Combiner
  def score_combination(items)
    items.reduce(0) { |sum, item| sum += item }
  end
end
