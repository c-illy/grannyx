# Hud
extends CanvasLayer

func _ready():
	var b = $"CurveOptionsContainer/ParamsContainer/InputBase"
	b.connect("value_changed", $"/root/Models", "_on_base_changed")
	Models.expBase = b.value
	
	var x = $"CurveOptionsContainer/ParamsContainer/InputX"
	x.connect("value_changed", $"/root/Models", "_on_columns_count_changed")
	
	var zx = $"CurveOptionsContainer/ZoomXContainer/ZoomXSlider"
	zx.connect("value_changed", $"/root/Models", "_on_zoom_x_changed")

	var zy = $"CurveOptionsContainer/ZoomYContainer/ZoomYSlider"
	zy.connect("value_changed", $"/root/Models", "_on_zoom_y_changed")
	zy.connect("value_changed", self, "_on_update_zoom_y", [], CONNECT_DEFERRED)
	
# warning-ignore:return_value_discarded
	($"/root/Models").connect("base_changed", self, "_on_update_y")
# warning-ignore:return_value_discarded
	($"/root/Models").connect("columns_count_changed", self, "_on_update_y")
	
	var lc = $CommentsContainer/LangChoice
	lc.connect("item_selected", $"/root/Models", "_on_locale_chosen", [], CONNECT_DEFERRED)
	($"/root/Models").connect("comments_changed", self, "_on_comments_changed")
	var langs = TranslationServer.get_loaded_locales()
	var i = 0
	var selecLang = 0
	for lang in langs :
		lc.add_item(lang, i)
#		print("%s : %s" % [lang, i])
		if(lang in TranslationServer.get_locale()) :
			selecLang = i
		i += 1
#	print("=> %s : %s" % [TranslationServer.get_locale(), selecLang])
	lc.select(selecLang)
	lc.emit_signal("item_selected", selecLang)

func _on_update_y():
	var y = pow(Models.expBase, Models.columnsCount - 1)
	var s = Models.humanizeFloat(y)
	$CurrentYLabel.text = "y = " + s

func _on_update_zoom_y(val):
	var zy = $"CurveOptionsContainer/ZoomYContainer/ZoomYSlider"
	if (val >= .999 * zy.max_value) and (val < 1000000) : #1000000 : max camera limit
		zy.max_value *= 2
		#print(zy.max_value)

func _on_comments_changed():
	$CommentsContainer/CommentsLabel.parse_bbcode(Models.comments)


