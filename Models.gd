#Models
extends Node

export var unitWidth = 20
export var expBase = 1.8
export var columnsCount = 1
export var zoomX = .4
export var zoomY = .3

signal base_changed
signal columns_count_changed
signal zoom_x_changed
signal zoom_y_changed

func _on_base_changed(newBase):
	expBase = newBase
	emit_signal("base_changed")

func _on_columns_count_changed(x):
	columnsCount = x + 1
	emit_signal("columns_count_changed")

func _on_zoom_x_changed(newZoomX):
	zoomX = newZoomX
	emit_signal("zoom_x_changed")

func _on_zoom_y_changed(newZoomY):
	zoomY = newZoomY
	emit_signal("zoom_y_changed")
