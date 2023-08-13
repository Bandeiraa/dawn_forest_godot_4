extends CharacterBody2D
class_name Player

const SPELL: PackedScene = preload("res://scenes/player/spell_area.tscn")

@onready var player_sprite: Sprite2D = get_node("Texture2D")
@onready var wall_ray: RayCast2D = get_node("WallRay")
@onready var stats: Node = get_node("Stats")

var spell_offset: Vector2 = Vector2(100, -50)

var direction: int = 1
var jump_count: int = 0

var dead: bool = false
var on_hit: bool = false
var landing: bool = false
var on_wall: bool = false
var attacking: bool = false
var defending: bool = false
var crouching: bool = false

var flipped: bool = false
var not_on_wall: bool = true
var can_track_input: bool = true

@export var speed: int
@export var jump_speed: int
@export var wall_jump_speed: int

@export var wall_gravity: int
@export var player_gravity: int
@export var magic_attack_cost: int
@export var wall_impulse_speed: int

func _physics_process(delta: float):
	horizontal_movement_env()
	vertical_movement_env()
	actions_env()
	
	gravity(delta)
	move_and_slide()
	player_sprite.animate(velocity)
	
	
func horizontal_movement_env() -> void:
	var input_direction: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if can_track_input == false or attacking:
		velocity.x = 0
		return
		
	velocity.x = input_direction * speed
	
	
func vertical_movement_env() -> void:
	if is_on_floor() or is_on_wall():
		jump_count = 0
		
	var jump_condition: bool = can_track_input and not attacking
	if Input.is_action_just_pressed("ui_select") and jump_count < 2 and jump_condition:
		jump_count += 1
		spawn_effect("res://scenes/effect/dust/jump.tscn", Vector2(0, 18), flipped)
		if next_to_wall() and not is_on_floor():
			velocity.y = wall_jump_speed
			velocity.x += wall_impulse_speed * direction
		else:
			velocity.y = jump_speed
			
			
func actions_env() -> void:
	attack()
	crouch()
	defense()
	
	
func attack() -> void:
	var attack_condition: bool = not attacking and not crouching and not defending and is_on_floor()
	if Input.is_action_just_pressed("attack") and attack_condition:
		attacking = true
		player_sprite.normal_attack = true
	elif Input.is_action_just_pressed("magic_attack") and attack_condition and stats.current_mana >= magic_attack_cost:
		attacking = true
		player_sprite.magic_attack = true
		stats.update_mana("Decrease", magic_attack_cost)
		
		
func crouch() -> void:
	if Input.is_action_pressed("crouch") and is_on_floor() and not defending:
		crouching = true
		stats.shielding = false
		can_track_input = false
	elif not defending:
		crouching = false
		can_track_input = true
		stats.shielding = false
		player_sprite.crouching_off = true
		
		
func defense() -> void:
	if Input.is_action_pressed("defense") and is_on_floor() and not crouching:
		defending = true
		stats.shielding = true
		can_track_input = false
	elif not crouching:
		defending = false
		can_track_input = true
		stats.shielding = false
		player_sprite.shield_off = true
		
		
func gravity(delta: float) -> void:
	if next_to_wall():
		velocity.y += wall_gravity * delta
		if velocity.y >= wall_gravity:
			velocity.y = wall_gravity
			
	else:
		velocity.y += delta * player_gravity
		if velocity.y >= player_gravity:
			velocity.y = player_gravity
			
			
func next_to_wall() -> bool:
	if wall_ray.is_colliding() and not is_on_floor():
		if not_on_wall:
			velocity.y = 0
			not_on_wall = false
			
		return true
		
	else:
		not_on_wall = true
		return false
		
		
func spawn_effect(effect_path: String, offset: Vector2, is_flipped: bool) -> void:
	var effect_instance: EffectTemplate = load(effect_path).instantiate()
	get_tree().root.call_deferred("add_child", effect_instance)
	if is_flipped:
		effect_instance.flip_h = true
		
	effect_instance.global_position = global_position + offset
	effect_instance.play_effect()
	
	
func spawn_spell() -> void:
	var spell: FireSpell = SPELL.instantiate()
	spell.spell_damage = stats.base_magic_attack + stats.bonus_magic_attack
	spell.global_position = global_position + spell_offset
	get_tree().root.call_deferred("add_child", spell)
	
	
func _exit_tree() -> void:
	if dead == true:
		return
		
	data_management.data_dictionary.player_position = global_position
	data_management.save_data()
	
	
func reset(state: bool) -> void:
	set_physics_process(not state)
	$Animation.play("idle")
