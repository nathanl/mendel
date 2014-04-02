# Mendel

Mendel breeds the best combinations of lists that you provide.

For example, suppose you have 100 shirts, 200 pairs of pants, and 50 hats, each with a price tag. How could you find the 50 cheapest outfits?

A brute force approach would build all 1 million possibilities (100 * 200 * 50), sort by price, and take the best 50. An ideal solution would build the best 50 and stop.

Mendel gets much closer to that ideal than a brute force approach by incrementally building candidates for the "next best" combination and using a priority queue to pull the best one at any given moment.

## Usage

Create a combiner class that knows how to score combinations of your items. Then provide sorted lists of items.

For example:

```ruby
# Simple lists of numbers. Any combination of these
# can be scored by adding them together
list1 = (1..100).to_a
list2 = (1.0..100.0).to_a

class NumericCombiner
  include Mendel::Combiner
  # Scores a combination from the two lists by adding them
  def score_combination(numbers)
    numbers.reduce(0) { |sum, number| sum += number }
  end
end

nc = NumericCombiner.new(list1, list2)
nc.take(50) # The 50 best combinations
```

A slightly more realistic example:

```ruby
shirts = Shirt.all
pants  = Pant.all
hats   = Hat.all

class ProductCombiner
  include Mendel::Combiner
  def score_combination(products)
    products.reduce(0) { |sum, product| sum += product.price}
  end
end

pc = ProductCombiner.new(shirts, pants, hats)
pc.take(50) # The 50 cheapest outfits
```

## Serialization and deserialization

Mendel::Combiner provides the instance methods `#dump` and `#dump_json` and the class methods `.load` and `.load_json`. This allows you to pause enumeration, save the data, and resume enumerating some time later.

## Caveats

1. **Single Enumeration**. For memory's sake, Mendel **does not keep** combinations it has returned to you. Combinations are built and flushed as you enumerate, so if you enumerate twice, there will be no data the second time; you will have to build a new combiner. If you need to keep the combinations, it is up to you to do so.
2. **Memory**. Producing ALL combinations of your lists in inherently expensive. Mendel shines at producing the N best. It will allow you to enumerate all of the combinations, but the more there are, the more memory it will need to queue them up. If you want the top 10,000 combinations, you'll probably be fine. If you want the top 10 billion, I hope you have lots of RAM.

## Installation

In Bundler:

    gem 'mendel', git: (this repo address)

## Naming

Mendel is named for [Gregor Mendel](https://en.wikipedia.org/wiki/Gregor_Mendel), "the father of modern genetics", a scientist and monk who discovered patterns of inheritance while breeding pea plants. The Mendel gem helps you breed the best possible hybrids of your data.
