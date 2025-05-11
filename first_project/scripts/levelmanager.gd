extends Node2D


@export var respawn_location : Vector2


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("resetpos"):
		_on_death_collider_player_died()

func _on_death_collider_player_died() -> void:
	$Player.velocity = Vector2.ZERO
	$Player.position = respawn_location
	$Player.get_node("Sprite2D").flip_h = false
