#EdgesColumn
extends Node2D

export (PackedScene) var Edge

export var edgesCount = 1
export var unitHeight = 1
export var yEndOffset = 0

var tmpEdgesCount = 0


func _ready():
	while tmpEdgesCount < edgesCount :
		var e = Edge.instance()
		add_child(e)
		var endX = Models.unitWidth
		var endY = yEndOffset - (unitHeight * tmpEdgesCount * 3.0)
		e.rotate(atan(endY/endX))
		tmpEdgesCount += 1
