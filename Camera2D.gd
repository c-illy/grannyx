extends Camera2D


func _ready():
# warning-ignore:return_value_discarded
	$"/root/Models".connect("zoom_x_changed", self, "_on_zoom_x_changed", [], CONNECT_DEFERRED)
# warning-ignore:return_value_discarded
	$"/root/Models".connect("zoom_y_changed", self, "_on_zoom_y_changed", [], CONNECT_DEFERRED)
	get_tree().get_root().connect("size_changed", self, "_on_zoom_y_changed", [], CONNECT_DEFERRED)
	_on_zoom_x_changed()
	_on_zoom_y_changed()

func _on_zoom_x_changed():
	zoom.x = Models.zoomX

func _on_zoom_y_changed():
	zoom.y = Models.zoomY
	transform.origin.y = - (OS.window_size.y - 10) * zoom.y
