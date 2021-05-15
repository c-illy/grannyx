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

func humanizeIntString(digits) :
	if digits.length() <= 3 :
		return digits
	else :
		var next = digits.substr(0, digits.length() - 3)
		var end = digits.substr(digits.length() - 3)
		return humanizeIntString(next) + " " + end

# digits = "k", with 0 < k < 1, eg. "0.020"
func humanizeDecimals(digits) :
	var L = digits.length()
	if L == 3 : # "0.3"
		return digits.substr(1) # ".3"
	if digits.substr(L-1) != "0" : #"0.00007"
		return digits.substr(1) #".00007"
	var res = humanizeDecimals(digits.substr(0, L-1))
	if res == ".0" : # digits = "0.000000" but number != 0
		return ".000000..." # to show precision limit
	return res

func _on_update_y():
	var y = pow(Models.expBase, Models.columnsCount - 1)
	var intY = floor(y)
	var s = "%d" % intY
	s = humanizeIntString(s)
	if (intY != y) : #not integer, add decimals
		var end = y - intY # .42
		var endS
		if intY <= 999 :
			endS = "%f" % end # "0.4201"
		else :
			endS = "%.1f" % end # "0.4"
		s = s + humanizeDecimals(endS)
	$CurrentYLabel.text = "y = " + s

func _on_update_zoom_y(val):
	var zy = $"CurveOptionsContainer/ZoomYContainer/ZoomYSlider"
	if (val >= .999 * zy.max_value) and (val < 1000000) : #1000000 : max camera limit
		zy.max_value *= 2
		#print(zy.max_value)
	
	
	
