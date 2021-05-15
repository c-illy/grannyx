extends Camera2D

var y0

func _ready():
	y0 = - ($"../Curve".transform.origin.y + 10)
# warning-ignore:return_value_discarded
	$"/root/Models".connect("zoom_x_changed", self, "_on_zoom_x_changed")
# warning-ignore:return_value_discarded
	$"/root/Models".connect("zoom_y_changed", self, "_on_zoom_y_changed")
	_on_zoom_x_changed()
	_on_zoom_y_changed()

func _on_zoom_x_changed():
	zoom.x = Models.zoomX

func _on_zoom_y_changed():
	zoom.y = Models.zoomY
	transform.origin.y = y0 * (zoom.y - 1)
