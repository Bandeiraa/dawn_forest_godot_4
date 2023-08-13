extends Area2D
class_name DetectionArea

@export var enemy: CharacterBody2D = null

func on_body_entered(body: Player) -> void:
	enemy.player_ref = body
	
	
func on_body_exited(_body: Player) -> void:
	enemy.player_ref = null
