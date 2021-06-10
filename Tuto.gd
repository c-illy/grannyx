# Tuto
extends Node2D


export var flashDuration = .3

var tutoStep = 0
var nbTicks = 1
var currTick = 0
var ticksTillUnfreeze = 0


func _ready():
	$Timer.wait_time = flashDuration
	($"/root/Models").connect("columns_count_changed", self, "_on_x_changed")


func _on_timeout() :
	if currTick < nbTicks :
		currTick += 1
	else :
		$Arrow.visible = !$Arrow.visible
		currTick = 0
	if tutoStep == 1 and ticksTillUnfreeze > 0 :
		ticksTillUnfreeze -= 1


func _on_x_changed() :
	if tutoStep == 0 :
		nbTicks = 4
		ticksTillUnfreeze = 6
		tutoStep = 1
		
	elif tutoStep == 1 :
		if ticksTillUnfreeze > 0 :
			ticksTillUnfreeze = 6 # re-cooldown
		else :
			$Arrow.queue_free()
			tutoStep = 2
			$Timer.stop()
			$Timer.disconnect("timeout", self, "_on_timeout")
			$Timer.queue_free()
		#queue_free()

#func _on_remove() :
#		queue_free()
