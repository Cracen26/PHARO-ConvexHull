Class {
	#name : #BaselineOfConvexHull,
	#superclass : #BaselineOf,
	#category : #BaselineOfConvexHull
}

{ #category : #baselines }
BaselineOfConvexHull >> baseline: spec [ 	
	<baseline>
	
	spec 
		for: #common
		do: [ spec package: 'ConvexHull'.
			spec group: 'default' with: #('FileDialog')]
]
