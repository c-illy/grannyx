#Models
extends Node

export var unitWidth = 20
export var unitHeight = 1
export var expBase = 2.7
export var columnsCount = 1
export var zoomX = .4
export var zoomY = .3
var comments
var tutoYComments
var tutoYBisComments
var tutoRecap

signal base_changed
signal columns_count_changed
signal zoom_x_changed
signal zoom_y_changed
signal comments_changed

func _on_base_changed(newBase):
	expBase = newBase
	emit_signal("base_changed")
	updateComments()
	emit_signal("comments_changed")

func _on_columns_count_changed(x):
	columnsCount = x + 1
	emit_signal("columns_count_changed")
	updateComments()
	emit_signal("comments_changed")

func _on_zoom_x_changed(newZoomX):
	zoomX = newZoomX
	emit_signal("zoom_x_changed")

func _on_zoom_y_changed(newZoomY):
	zoomY = newZoomY
	emit_signal("zoom_y_changed")

func _on_locale_chosen(langI):
	TranslationServer.set_locale(TranslationServer.get_loaded_locales()[langI])
	updateComments()
	emit_signal("comments_changed")

func updateComments():
	#if covid example or...
	var monthDays = 365.25 / 12
	var y = pow(Models.expBase, Models.columnsCount - 1)
	var intY = humanizeIntString("%d" % int(floor(y)))
	if y == floor(y) :
		y = intY
	else :
		y = "%.1f" % y
	var prevY = pow(Models.expBase, Models.columnsCount - 2)
	if prevY == floor(prevY) :
		prevY = humanizeIntString("%d" % int(prevY))
	else :
		prevY = "%.1f" % prevY
	var yKnown = pow(Models.expBase, Models.columnsCount - 3)
	var xTwoMonths = (Models.columnsCount - 1) + ((2 * monthDays) / 5.2)
	var yTwoMonths = pow(Models.expBase, xTwoMonths)
	var xEnd = log(8000000000)/log(expBase)
	var yXEndMinus3 = 8000000000/expBase/expBase/expBase
	var monthsBeforeEnd = (xEnd - (Models.columnsCount - 1)) * 5.2 / monthDays
	
	var placeHolders = {
		"expBase": "%.1f" % expBase,
		"x": columnsCount - 1,
		"x_days": "%.1f" % ((columnsCount - 1) * 5.2),
		"y": intY,
		"y_known": humanizeFloat(yKnown),
		"x_two_months": "%.2f" % xTwoMonths,
		"y_two_months": humanizeFloat(yTwoMonths),
		"x_end": "%.2f" % xEnd,
		"months_before_end" : "%.2f" % monthsBeforeEnd,
		"x_end_months": "%.2f" % (xEnd * 5.2 / monthDays),
		"y_xend_minus_3": humanizeIntString("%d" % int(yXEndMinus3))
	}
	comments = tr("COMMENT_COVID").format(placeHolders)
	
	tutoYComments = (tr("Y_HERE").format({"y" : y})) + "\n" + tr("Y_HERE_X")
	tutoYBisComments = tr("FORMIDABLE").format({"prev_y" : prevY})
	tutoRecap = tr("RECAP")

func humanizeIntString(digits) :
	if digits.length() <= 3 :
		return digits
	else :
		var next = digits.substr(0, digits.length() - 3)
		var end = digits.substr(digits.length() - 3)
		return humanizeIntString(next) + " " + end

func humanizeFloat(floatVal) :
	var intVal = floor(floatVal)
	var s = "%d" % intVal
	s = humanizeIntString(s)
	if (intVal != floatVal) : #not integer, add decimals
		var end = floatVal - intVal # .42
		var endS
		if intVal <= 999 :
			endS = "%f" % end # "0.4201"
		else :
			endS = "%.1f" % end # "0.4"
		s = s + humanizeDecimals(endS)
	return s

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
