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
		$Timer.queue_free()

func _on_remove() :
		queue_free()
