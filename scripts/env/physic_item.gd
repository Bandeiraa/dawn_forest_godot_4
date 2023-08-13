extends RigidBody2D
class_name PhysicItem

const COLLECT_EFFECT: PackedScene = preload("res://scenes/effect/general_effects/collect_item.tscn")

@onready var sprite: Sprite2D = get_node("Texture2D")

var player_ref: CharacterBody2D = null

var item_name: String
var item_info_list: Array
var item_texture: CompressedTexture2D

func _ready() -> void:
	randomize()
	apply_random_impulse()
	
	
func apply_random_impulse() -> void:
	apply_impulse(
		Vector2.ZERO,
		Vector2(
			randf_range(-60, 60),
			-90
		)
	)
	
	
func update_item_info(key: String, texture: CompressedTexture2D, item_info: Array) -> void:
	await self.ready
	
	item_name = key
	item_texture = texture
	item_info_list = item_info
	
	sprite.texture = texture
	
	
func on_screen_exited():
	queue_free()
	
	
func on_body_entered(body: Player):
	player_ref = body
	
	
func on_body_exited(_body: Player):
	player_ref = null
	
	
func _process(_delta: float) -> void:
	if player_ref != null and Input.is_action_just_pressed("interact"):
		get_tree().call_group("inventory", "update_slot", item_name, item_texture, item_info_list)
		spawn_effect()
		queue_free()
		
		
func spawn_effect() -> void:
	var collect_effect: EffectTemplate = COLLECT_EFFECT.instantiate()
	get_tree().root.call_deferred("add_child", collect_effect)
	collect_effect.global_position = global_position
	collect_effect.play_effect()
