# TODO

- Queue should contain only the coordinates and associated scores, not the combinations themselves. We can re-build those before returning. This is a slight performance cost but should help with memory consumption. Would also make dumped data smaller.
- Make Combiner a class again; require Scorer object in initialize method that responds to `.call` AND is serializable. (grr)
- Maybe do some refactoring in Combiner so that Observable the `notify` calls could be removed from it (not really part of its core responsibility) and added in a visualization-specific subclass via `super.tap{notify...}`
- Have a rake task that runs through some combination scenarios (2 lists only) and draws the progress through the grid. Eg, start with items drawn on the axes but nothing in the middle, put a numeric value on a coordinate when its score is calculated. (Maybe output an HTML/jQuery animation?)
- Use colorize gem for ASCII output
