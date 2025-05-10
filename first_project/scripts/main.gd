extends Node2D


@onready var levelroot : Node2D = $LevelHolder
@onready var menuroot : Control = $MenuHolder

var currentlevel : String = "Level0"
var currentmenu : String


func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		level_select("Level0")


func level_select(level):
	print("loading")
	# unload currently active level
	if currentlevel != null:
		var oldlevel = levelroot.get_node(currentlevel)
		levelroot.remove_child(oldlevel)
	
	# remove menus
	for n in menuroot.get_children():
		menuroot.remove_child(n)
		n.queue_free()
	
	# load level
	var newlevel = load("scenes/" + level + ".tscn")
	var loadedlevel = newlevel.instantiate()
	levelroot.add_child(loadedlevel)
	currentlevel = level
	print(currentlevel)


func _on_level_select_menu_load_level(level: Variant) -> void:
	print("loading")
	# unload currently active level
	if currentlevel != null:
		var oldlevel = levelroot.get_node(currentlevel)
		levelroot.remove_child(oldlevel)
	
	# remove menus
	for n in menuroot.get_children():
		menuroot.remove_child(n)
		n.queue_free()
	
	# load level
	var newlevel = load("scenes/" + level + ".tscn")
	var loadedlevel = newlevel.instantiate()
	levelroot.add_child(loadedlevel)
	currentlevel = level
	print(currentlevel)
