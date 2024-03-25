### Convex Hull 
A set of 5 points the generated convex hull composed by 4 segments.

```
points := OrderedCollection new.

points
	add: 1@2; add: 2@3; add: 3@2; add: 3@4; add: 4@4.

cvx := ConvexHull new.

cvx generateHull: points.
```
