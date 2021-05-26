# Tuto
extends Node2D


export var nbFlashes = 15
export var flashDuration = .5


func _ready():
	$Timer.wait_time = flashDuration

func _on_timeout() :
	if nbFlashes > 0 :
		$Arrow.visible = !$Arrow.visible
		nbFlashes -= 1
	else :
		$Arrow.visible = true
		remove_child($Timer)

func _on_remove() :
		get_parent().remove_child(self)
