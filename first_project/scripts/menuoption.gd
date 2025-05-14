extends Area2D


#@onready var mode_text = $"../MarginContainer"


@export var menu_name : String
@export var enter_animate : bool = false


var entered : bool = false


func _ready() -> void:
	entered = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and entered:
		Signals.menu_selected.emit(menu_name)


func _on_body_entered(_body: Node2D) -> void:
	entered = true
	#mode_text = move_toward(0, 1, 5)
	
	if enter_animate:
		$Sprite2D.frame = 1


func _on_body_exited(_body: Node2D) -> void:
	entered = false
	
	
	if enter_animate:
		$Sprite2D.frame = 0
