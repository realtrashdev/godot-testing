extends Control


signal load_level(level)


func _on_level_select_button_level_selected(level: Variant) -> void:
	load_level.emit(level)
	print("dude")
