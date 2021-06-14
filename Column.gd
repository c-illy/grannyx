#Column
extends Node2D

export (PackedScene) var UnitSprite
export (PackedScene) var EdgesColumn

export var unitsCount = 1

var tmpUnitsCount = 0
#var h = 1 #use Models.unitHeight instead

#var tmpMultiDelta = 0


#creation-time blocking version
#func _ready():
#	for i in unitsCount:
#		var u = UnitSprite.instance()
#		add_child(u)
#		var h = u.scale.y
#		u.position.y = - h * i *.05#* 1.25
#		u.texture.width = Models.unitWidth;

#scale version
func _process(delta):
	
	#fill column bottom with individual units, but only the 90 first ones
	while (tmpUnitsCount <= 90) and (tmpUnitsCount < unitsCount) :
		var u = UnitSprite.instance()
		add_child(u)
		Models.unitHeight = u.scale.y
		u.position.y = - Models.unitHeight * tmpUnitsCount * 3
		u.texture.width = Models.unitWidth;
		tmpUnitsCount += 1
	
	#skip a few frames
#	tmpMultiDelta += delta
#	var multiDeltaLimit = .1
#	if tmpMultiDelta < multiDeltaLimit :
#		return
	
	#then continue filling by y-scaling up last unit
	if tmpUnitsCount < unitsCount :
		var fillRatioSpeed = 1.5 # ratio of whole column to fill in one second
		var deltaRatio = fillRatioSpeed * delta #tmpMultiDelta
		var deltaU = deltaRatio * unitsCount
		#now forget about ratios
		tmpUnitsCount += deltaU # unless too high :
		if tmpUnitsCount > unitsCount :
			tmpUnitsCount = unitsCount
		var iLast = get_child_count() - 1
		var u = get_child(iLast) # last unit
		#h = get_child(0).scale.y
		u.scale.y = Models.unitHeight * (tmpUnitsCount - iLast) * 3
		u.position.y = - Models.unitHeight * (tmpUnitsCount-1) * 3
	else : #end, add edges and unregister _process() method
		var x = get_index()
		if (0 < x) && (x < 3):
			var e = EdgesColumn.instance()
			e.edgesCount = unitsCount
			e.unitHeight = Models.unitHeight
			add_child(e)
			e.position.x = -Models.unitWidth
		set_process(false) #unsignificant impact but good practice when possible
	
#	tmpMultiDelta = 0

#multi-unit version
#func _process(delta):
#
#	#fill column bottom with individual units, but only the 'expBase' first ones
#	while (tmpUnitsCount <= ceil(Models.expBase)) and (tmpUnitsCount < unitsCount) :
#		var u = UnitSprite.instance()
#		add_child(u)
#		var h = u.scale.y
#		u.position.y = - h * tmpUnitsCount * 3
#		u.texture.width = Models.unitWidth;
#		tmpUnitsCount += 1
#
#	#skip a few frames
#	tmpMultiDelta += delta
#	var multiDeltaLimit = .1
#	if tmpMultiDelta < multiDeltaLimit :
#		return
#
#	#then continue filling with multi unit blocks
#	if tmpUnitsCount < unitsCount :
#		var fillSpeed = 1.2 # ratio of whole column to fill in one second
#		var deltaRatio = fillSpeed * tmpMultiDelta
#		var oldRatio = tmpUnitsCount / unitsCount
#		var newRatio = min(1, oldRatio + deltaRatio)
#		var u = UnitSprite.instance()
#		add_child(u)
#		var h = u.scale.y
#		u.texture.width = Models.unitWidth;
#		var deltaUnitsCount = (newRatio - oldRatio) * unitsCount
#		u.scale.y = h * deltaUnitsCount * 3
#		tmpUnitsCount += deltaUnitsCount
#		u.position.y = - h * (tmpUnitsCount-1) * 3
#	else : #end, unregister _process() method
#		set_process(false) #unsignificant impact but good practice when possible
#
#	tmpMultiDelta = 0

#naive version
#func _process(delta):
#	var nbInstancesPerFrame = delta*1000#(unitsCount / 20)
#	var lastInstanceThisFrame = min(
#		unitsCount, 
#		tmpUnitsCount + nbInstancesPerFrame)
#	while tmpUnitsCount < lastInstanceThisFrame :
#		var u = UnitSprite.instance()
#		add_child(u)
#		var h = u.scale.y
#		u.position.y = - h * tmpUnitsCount * 3
#		u.texture.width = Models.unitWidth;
#		tmpUnitsCount += 1
#	if tmpUnitsCount == unitsCount :
#		set_process(false) #unsignificant impact but good practice when possible

#shorter-child-lists version : no improvement
#var oldParent ########
##func _process(delta):
##	var nbInstancesPerFrame = delta*1000#(unitsCount / 20)
##	var lastInstanceThisFrame = min(
##		unitsCount, 
##		tmpUnitsCount + nbInstancesPerFrame)
##	if tmpUnitsCount == 0 : #########
##		oldParent = self #############
##	var u
##	var i = 1
##	while tmpUnitsCount <= lastInstanceThisFrame :
##		u = UnitSprite.instance()
##		oldParent.add_child(u) ############add_child(u)
##		var h = u.scale.y
##		u.position.y = - h * i * .05 ############ u.position.y = - h * tmpUnitsCount *.05#* 1.25#
##		u.texture.width = Models.unitWidth;
##		tmpUnitsCount += 1
##		i += 1
##	oldParent = u #################
##	if tmpUnitsCount == unitsCount :
##		set_process(false) #unsignificant impact but good practice when possible
