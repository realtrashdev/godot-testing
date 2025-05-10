extends Button


signal level_selected(level)


@export var level_number : String


var level_name : String


func _ready() -> void:
	level_name = "Level" + level_number
	text = "Level " + level_number


func _on_pressed() -> void:
	level_selected.emit(level_name)
	print(text + " Selected")
