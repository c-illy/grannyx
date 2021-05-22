#EdgesColumn
extends Node2D

export (PackedScene) var Edge

export var edgesCount = 1
export var unitHeight = 1

var tmpEdgesCount = 0


func _ready():
	while tmpEdgesCount < edgesCount :
		var e = Edge.instance()
		add_child(e)
		var endX = Models.unitWidth
		var endY = - unitHeight * tmpEdgesCount * 3.0
		var startY = endY / Models.expBase
		e.rotate(atan((endY-startY)/endX))
		e.position.y = startY
		tmpEdgesCount += 1
