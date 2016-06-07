# Mendel

Mendel breeds the best combinations of sorted lists that you provide.

For example, suppose you have 100 shirts, 200 pairs of pants, and 50 hats, ordered by price. How could you find the 50 cheapest outfits?

A brute force approach would build all 1 million possibilities (100 * 200 * 50), sort by price, and take the best 50. An ideal solution would build the best 50 and stop.

Mendel gets much closer to the ideal by incrementally building candidates for the "next best" combination and using a priority queue to pull the best one at any given moment.

## How it Works

Mendel is easiest to explain for two lists. In that case, we can think of the combinations as a grid, where the X value is from the first list and the Y value is from the second. Inside the grid, we can represent combinations as the sum of the coordinate values.

**The lists must be sorted by score**. This means that the sums will increase (or remain constant) along one or both axes.

For example, imagine that these grids are landscapes, and the scores in the middle are elevations. **Mendel chooses combinations like a tide, rising from the bottom left.**

     +---+    +---+    +---+    +---+
    1|555|   1|567|   3|777|   3|789|
    1|555|   1|567|   2|666|   2|678|
    1|555|   1|567|   1|555|   1|567|
     +---+    +---+    +---+    +---+
      444      456      444      456 

In every case, we are guaranteed that the bottom left corner - the best item from list Y combined with the best item from list X - has the lowest elevation. Beyond that, the next best combination could be at `0,1` or `1,0`; we don't know. All we can do is check them both and choose the best one. "Check them both" means producing a score, and to "choose the best one", Mendel uses a [priority queue](https://en.wikipedia.org/wiki/Priority_queue).

If we find that we've chosen `0,1`, before we return it, we add `1,1` and `0,2` to the queue. We don't know yet whether either of them is better than `1,0`, but next time we need a value, the priority queue will decide. So the water line continues to move up and to the right. Any coordinate "under water" has been returned, any coordinate above the water line has not yet been scored, and any coordinate the water line is just touching is a combination that's currently in the priority queue, 

Run `rake visualize` to see this process in action.

Mendel does the same process for combinations of 3 or more lists, too. Imagining a 6-dimensional graph is beyond the author's cognitive abilities, but in principle, it's the same.

## Usage

Create a combiner class that knows how to score combinations of your items. Then provide lists of items, sorted in ascending value.

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

Mendel will return two-item arrays of `[combination, score]`.

A combination of items is, by default, an array with one item from each list. However, if you like, you may specify how to build combinations of your items.

```ruby
defense_players = [{name: 'Jimmy', age: 10}, {name: 'Susan', age: 12}]
offense_players = [{name: 'Roger', age: 8},  {name: 'Carla',  age: 14}]

class FoosballTeam
  attr_accessor :players

  def initialize(*players)
    self.players = players
  end

  def average_age
    players.reduce(0){ |total, player|
      total += player.fetch(:age)
    } / 2.0
  end
end

class TeamBuilder
  include Mendel::Combiner

  def build_combination(players)
    FoosballTeam.new(*players)
  end

  def score_combination(team)
    team.average_age
  end
end

pc = TeamBuilder.new(defense_players, offense_players)
pc.take(2) # The youngest teams
```

If you need to apply other criteria besides the score, use lazy enumeration and chain other calls:

```ruby
  pc.each.lazy.reject { |team, score| team.contains_siblings? }.take(50).to_a
```

## Serialization and deserialization

`Mendel::Combiner` provides the instance methods `#dump` and `#dump_json` and the class methods `.load` and `.load_json`. This allows you to pause enumeration, save the data, and resume enumerating some time later.

## Caveats

1. **Single Enumeration**. For memory's sake, Mendel **does not keep** combinations it has returned to you. Combinations are built and flushed as you enumerate, so if you enumerate twice, there will be no data the second time; you will have to build a new combiner. If you need to keep the combinations, it is up to you to do so.
2. **Memory**. Producing ALL combinations of your lists in inherently expensive. Mendel shines at producing the N best. It will allow you to enumerate all of the combinations, but the more there are, the more memory it will need to queue them up. If you want the top 10,000 combinations, you'll probably be fine. If you want the top 10 billion, I hope you have lots of RAM.

## Installation

In Bundler:

    gem 'mendel', git: (this repo address)

## Naming

Mendel is named for [Gregor Mendel](https://en.wikipedia.org/wiki/Gregor_Mendel), "the father of modern genetics", a scientist and monk who discovered patterns of inheritance while breeding pea plants. The Mendel gem helps you breed the best possible hybrids of your data.
