extends Sprite2D
class_name EnemyTexture

@export var attack_area_collision: CollisionShape2D = null
@export var animation: AnimationPlayer = null
@export var enemy: CharacterBody2D = null

func animate(_velocity: Vector2) -> void:
	pass
	
	
func on_animation_finished(_anim_name: String) -> void:
	pass
