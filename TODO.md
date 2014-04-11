# TODO

- Pretty documentation

# Probably Not TODO

## Memory Optimization

We currently track a set of all seen coordinates. As we build combinations, the size of the set approaches the total number of possible combinations. Although each item in the set is very small (an array of fixnums), the number can grow large.

The purpose of the set is to keep from queuing the same coordinates repeatedly (eg, [1,1] could be queued as a child of [1,0] and again as a child of [0,1]). We could save memory by not remembering every coordinate we've seen and rejecting subsequent attempts to score that spot; rather, for this purpose it's probably enough to have the priority queue reject duplicates of what it currently has in it. This would make the set an order of magnitude smaller: instead of having every coordinate in a grid (2D), it would have only the advancing edge (1D), or instead of every coordinate in a cube, only the advancing surface.

This only works if we can assume that a child will never be returned before its parent; eg, [1,1] won't be returned before [0,1]; if it were, when [0,1] got returned, [1,1] would be queued again. That assumption, in turn, is only true if we don't have duplicate scores, which we very well might. In that case, if [0,1] and [1,1] are both scored 10, we can make no guarantees about which will be returned first. A workaround is to give to the priority queue a score consisting of the "normal" score PLUS the coordinates; eg, [10, [1,1]]. This guarantees that children have higher scores than parents.

A test indicated that this does save memory, but it seems not to be worth the trouble. It makes the code more complicated and, in an upper bound use case for me, consisting of 10 lists of 200 items each and pulling (I think) 40k results, it saved (I think) something like 100MB. So I scrapped it. I record this here only because someone may have a use case where it matters, and an order of magnitude in memory use may be important for them. So: free idea.
