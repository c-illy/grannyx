# Hud
extends CanvasLayer

var tutoON = true

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
	
	var cl = $CommentsContainer/CommentsLabel
	cl.rect_min_size.y = OS.window_size.y - 120
# warning-ignore:return_value_discarded
	get_tree().get_root().connect("size_changed", self, "_on_window_resize", [], CONNECT_DEFERRED)
	
	#https://godotengine.org/qa/46978/how-do-i-open-richtextlabel-bbcode-links-in-an-html5-export
	var ll = $CommentsContainer/LinksLabel
	ll.connect("meta_clicked", self, "_on_LinksLabel_meta_clicked", [], CONNECT_DEFERRED)
	
	var lc = $CommentsContainer/CommentsButtonsContainer/LangChoice
	lc.connect("item_selected", $"/root/Models", "_on_locale_chosen", [], CONNECT_DEFERRED)
# warning-ignore:return_value_discarded
	($"/root/Models").connect("comments_changed", self, "_on_comments_changed", [], CONNECT_DEFERRED)
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
	if tutoON :
		$CurveOptionsContainer/ParamsContainer/InputX/Tuto.queue_free()
		tutoON = false

func _on_update_zoom_y(val):
	var zy = $"CurveOptionsContainer/ZoomYContainer/ZoomYSlider"
	if (val >= .999 * zy.max_value) and (val < 1000000) : #1000000 : max camera limit
		zy.max_value *= 2
		#print(zy.max_value)

func _on_comments_changed():
	$CommentsContainer/CommentsLabel.parse_bbcode(Models.comments)
	$CommentsContainer/LinksLabel.parse_bbcode(tr("LINKS"))

func _on_see_comments():
	$CommentsContainer/CommentsLabel.visible = !$CommentsContainer/CommentsLabel.visible
	$CommentsContainer/LinksLabel.visible = !$CommentsContainer/LinksLabel.visible

#https://godotengine.org/qa/46978/how-do-i-open-richtextlabel-bbcode-links-in-an-html5-export
func _on_LinksLabel_meta_clicked(meta):
	#OS.shell_open(meta) #blocked by firefox
#	var jsCode = "window.open(\"%s\", '_blank');" % meta #blocked by firefox
	var jsCode = "window.open(\"%s\",'_self');" % meta
	#print(jsCode)
	JavaScript.eval(jsCode);

func _on_window_resize():
	$CommentsContainer/CommentsLabel.rect_min_size.y = OS.window_size.y - 120

