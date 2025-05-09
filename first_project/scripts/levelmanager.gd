extends Node2D


@export var player_respawn : Vector2


func _on_death_collider_player_died() -> void:
	$Player.velocity = Vector2.ZERO
	$Player.position = player_respawn
