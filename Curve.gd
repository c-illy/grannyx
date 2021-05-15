#Curve
extends Node2D

export (PackedScene) var Column

var tmpColumnsCount = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/Models".connect("base_changed", self, "_on_base_changed")
	$"/root/Models".connect("columns_count_changed", self, "_on_columns_count_changed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var w = Models.unitWidth
	while tmpColumnsCount < Models.columnsCount :
#	for i in Models.columnsCount:
		var c = Column.instance()
		c.unitsCount = ceil(pow(Models.expBase, tmpColumnsCount))
		c.position.x = w * tmpColumnsCount * 2
		add_child(c)
		tmpColumnsCount += 1
	while tmpColumnsCount > Models.columnsCount :
		remove_child(get_child(get_child_count() - 1))
		tmpColumnsCount -= 1
	set_process(false)

func _on_base_changed() :
	var i = get_child_count() - 1
	while i > 0 :
		remove_child(get_child(i))
		i -= 1
	tmpColumnsCount = 1
	set_process(true)

func _on_columns_count_changed() :
	set_process(true)
