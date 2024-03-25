Class {
	#name : #ConvexHull,
	#superclass : #Object,
	#instVars : [
		'hull'
	],
	#category : #ConvexHull
}

{ #category : #display }
ConvexHull >> displayDistribution: points [
	
]

{ #category : #convex }
ConvexHull >> generateHull: points [
	"generate the point we have to link to have the envelope convex"
	|sortedPoints convexHull segment pointsWithoutIncline vect|
	
	points size < 3 ifTrue: [ Error signal: 'Convex Hull require at least 3 points' ].
	
	sortedPoints := self sortByAngle: points.
	
	convexHull := OrderedCollection new.
	pointsWithoutIncline := OrderedCollection new.
	
	sortedPoints do: [ :each |
		pointsWithoutIncline add: (each at: 1) 
	].
	
	pointsWithoutIncline withIndexDo: [ :each :i |
		segment := OrderedCollection new.
		i = 1 ifTrue: [ 
			segment add: (pointsWithoutIncline at: 1).
			segment add: (pointsWithoutIncline at: 2).
		
			convexHull add: segment.
		].
	
		(i > 1 and: (i ~= pointsWithoutIncline size )) ifTrue: [ 
			vect := self vectorialProduct: (pointsWithoutIncline at: i-1) secondPoint: (pointsWithoutIncline at: i)  thirdPoint: (pointsWithoutIncline at: i+1).
			vect > 0 ifTrue: [ 
				segment add: (pointsWithoutIncline at: i).
				segment add: (pointsWithoutIncline at: i+1).
				
				convexHull add: segment .
			].
		
			vect < 0 ifTrue: [
				convexHull removeAt: (convexHull size).
				
				segment add: (pointsWithoutIncline at: i-1).
				segment add: (pointsWithoutIncline at: i+1).
				
				convexHull add: segment
			]
		].
		
		i == pointsWithoutIncline size ifTrue: [ 
			segment add: (pointsWithoutIncline at: i).
			segment add: (pointsWithoutIncline at: 1).
			
			convexHull add: segment .
		]
		
	].

	^ convexHull .
	

]

{ #category : #utilities }
ConvexHull >> getPivot: points [
	|ymin xmin pointsYMin |
	
	ymin := ((self sortByYCoordinate: points) at: 1) y.
	
	pointsYMin := points select: [ : each | each y == ymin].
	
	xmin := ((self sortByXCoordinate: pointsYMin) at: 1) x.
	
	^ xmin@ymin
	
]

{ #category : #accessing }
ConvexHull >> hull [

	^ hull
]

{ #category : #accessing }
ConvexHull >> hull: anObject [

	hull := anObject
]

{ #category : #utilities }
ConvexHull >> incline: aPointA and: aPointB [
	|deltaY deltaX incline|
	
	deltaY := aPointB y - aPointA y.
	deltaX := aPointB x - aPointA x.

	deltaX == 0 ifTrue: [ incline := 100 ]
					ifFalse: [ incline := deltaY / deltaX  ].
					
	^ incline
]

{ #category : #utilities }
ConvexHull >> sortByAngle: points [
	"by computing inclinaison we can sort angle. sortedPointsBy"
	|pivot pointsAndIncline iteration pointsWithoutPivot first|
	
	pointsAndIncline := OrderedCollection new.
	first := OrderedCollection new.

	pivot := self getPivot: points.
	
	first add: pivot.
	first add: -100. "min incline value"
	
	pointsAndIncline add: first. 
	
	pointsWithoutPivot := points reject: [:each | ((each x = pivot x) and: (each y = pivot y))].
	
	pointsWithoutPivot do: [ :each |
		iteration := OrderedCollection new.
		iteration add: each.
		iteration add: ( self incline: pivot and: each ).
		
		pointsAndIncline add: iteration.
	].
	
	^ pointsAndIncline asSortedCollection: [ :p1 :p2 | (p1 at: 2) < (p2 at: 2) ].
	
]

{ #category : #utilities }
ConvexHull >> sortByXCoordinate: points [
	^ points asSortedCollection: [ :p1 :p2 | p1 x < p2 x ].
]

{ #category : #utilities }
ConvexHull >> sortByYCoordinate: points [

	^ points asSortedCollection: [ :p1 :p2 | p1 y < p2 y ].
]

{ #category : #utilities }
ConvexHull >> vecteur: aPoint secondPoint: aPoint1 [
|deltaX deltaY|
	
	deltaX := (aPoint1 x - aPoint x).
	deltaY := (aPoint1 y - aPoint y).
	
	^ deltaX@deltaY 
]

{ #category : #utilities }
ConvexHull >> vectorialProduct: aPoint1 secondPoint: aPoint2 thirdPoint: aPoint3 [
"if return >0 the third point is left to the droite aVector"
	| v1 v2|
	v1 := self vecteur: aPoint1 secondPoint: aPoint2 .
	v2 := self vecteur: aPoint1 secondPoint: aPoint3 . 
	
	^ (v1 x * v2 y) - (v1 y * v2 x)
]
