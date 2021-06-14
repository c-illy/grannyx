# Tuto
extends Node2D


export var flashDuration = .3

var tutoStep = 0
var nbTicks = 1
var currTick = 0
var ticksTillUnfreeze = 0
var commentsShown = false


func _ready():
	$Timer.wait_time = flashDuration
	# warning-ignore:return_value_discarded
	$"/root/Models".connect("columns_count_changed", self, "_on_x_changed", [], CONNECT_DEFERRED)


func _on_timeout() :
	if currTick < nbTicks :
		currTick += 1
	else :
		$TutoX.visible = !$TutoX.visible
		currTick = 0
	if tutoStep == 1 and ticksTillUnfreeze > 0 :
		ticksTillUnfreeze -= 1


func _on_x_changed() :
	if tutoStep == 0 : # 0->1
		nbTicks = 4
		ticksTillUnfreeze = 6
		$"/root/Models".connect("zoom_x_changed", self, "_on_tutoY_pos_changed", [], CONNECT_DEFERRED)
		$"/root/Models".connect("zoom_y_changed", self, "_on_tutoY_pos_changed", [], CONNECT_DEFERRED)
		get_tree().get_root().connect("size_changed", self, "_on_tutoY_pos_changed", [], CONNECT_DEFERRED)
		$"/root/Models".connect("base_changed", self, "_on_tutoY_pos_changed", [], CONNECT_DEFERRED)
		$"/root/Models".connect("columns_count_changed", self, "_on_tutoY_pos_changed", [], CONNECT_DEFERRED)
		$"/root/Models".connect("comments_changed", self, "_on_tuto_text_changed", [], CONNECT_DEFERRED)
		Models.updateComments()
		_on_tutoY_pos_changed()
		$TutoY.visible = true
		tutoStep = 1
		
	elif tutoStep == 1 : # 1->2
		if ticksTillUnfreeze > 0 :
			ticksTillUnfreeze = 6 # re-cooldown
		else :
			$Recap.visible = true
			$TutoX.queue_free()
			$Timer.stop()
			$Timer.disconnect("timeout", self, "_on_timeout")
			$Timer.queue_free()
			tutoStep = 2
			
			
	elif 2 <= tutoStep and tutoStep <= 4 : # 2->3,4,5
		tutoStep += 1
		if tutoStep == 5 :
			if !commentsShown : # 4->5
				$TutoComments.visible = true
			else :
				destruct() # 4(5)->end


func _on_see_comments():
	commentsShown = true
	if tutoStep == 5 : # 5->end
		destruct()


func _on_tutoY_pos_changed() :
	var tyX = (Models.columnsCount - .4) * Models.unitWidth * 2
	var mx = (Models.columnsCount - 1)
	var tyY = - pow(Models.expBase, mx) * Models.unitHeight * 3
	$TutoY.position.x = int(tyX / Models.zoomX) - position.x
	$TutoY.position.y = int(tyY / Models.zoomY) + OS.window_size.y - position.y
	_on_tuto_text_changed()
	if tutoStep == 5 :
		$TutoComments.position.x = OS.window_size.x - position.x - 66
		$TutoComments.position.y = (OS.window_size.y * .04) - position.y - 23


func _on_tuto_text_changed() :
	$TutoY/HContainer/Bubble.parse_bbcode(Models.tutoYComments)
	$TutoY/HContainer/Bubble/BubbleBis.parse_bbcode(Models.tutoYBisComments)
	$Recap.parse_bbcode(Models.tutoRecap)


func destruct() :
	$"/root/Models".disconnect("columns_count_changed", self, "_on_x_changed")
	$"/root/Models".disconnect("zoom_x_changed", self, "_on_tutoY_pos_changed")
	$"/root/Models".disconnect("zoom_y_changed", self, "_on_tutoY_pos_changed")
	get_tree().get_root().disconnect("size_changed", self, "_on_tutoY_pos_changed")
	$"/root/Models".disconnect("base_changed", self, "_on_tutoY_pos_changed")
	$"/root/Models".disconnect("columns_count_changed", self, "_on_tutoY_pos_changed")
	$"/root/Models".disconnect("comments_changed", self, "_on_tuto_text_changed")
	queue_free()


#func _on_remove() :
#		queue_free()
