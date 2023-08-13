extends Node
class_name PlayerStats

@onready var invencibility_timer: Timer = get_node("InvencibilityTimer")

var shielding: bool = false

var base_health: int = 15
var base_mana: int = 10
var base_attack: int = 1
var base_magic_attack: int = 3
var base_defense: int = 1

var bonus_health: int = 0
var bonus_mana: int = 0
var bonus_attack: int = 0
var bonus_magic_attack: int = 0
var bonus_defense: int = 0

var current_mana: int
var current_health: int

var max_mana: int
var max_health: int

var current_exp: int = 0

var level: int = 1
var level_dict: Dictionary = {
	"1": 25,
	"2": 33,
	"3": 49,
	"4": 66,
	"5": 93,
	"6": 135,
	"7": 186,
	"8": 251,
	"9": 356
}

@export var floating_text: PackedScene

@export var player: CharacterBody2D = null
@export var collision_area: Area2D = null

func _ready() -> void:
	if FileAccess.file_exists(data_management.save_path):
		data_management.load_data()
		level = data_management.data_dictionary.current_level
		current_exp = data_management.data_dictionary.current_exp
		
		current_mana = data_management.data_dictionary.current_mana
		current_health = data_management.data_dictionary.current_health
		
		update_stats_with_serialized_data()
		
		get_tree().call_group("bar_container", "init_bar", max_health, max_mana, level_dict[str(level)])
		get_tree().call_group("bar_container", "reset_exp_bar", level_dict[str(level)], current_exp)
		
		get_tree().call_group("bar_container", "update_bar", "ManaBar", current_mana)
		get_tree().call_group("bar_container", "update_bar", "HealthBar", current_health)
		
	update_stats_hud()
	
	
func update_stats_with_serialized_data() -> void:
	var base_stats: Array = data_management.data_dictionary.base_stats
	
	base_health = base_stats[0]
	base_mana = base_stats[1]
	base_attack = base_stats[2]
	base_magic_attack = base_stats[3]
	base_defense = base_stats[4]
	
	max_mana = base_mana + bonus_mana
	max_health = base_health + bonus_health
	
	
func update_exp(value: int) -> void:
	current_exp += value
	spawn_floating_text("+", "Exp", value)
	get_tree().call_group("bar_container", "update_bar", "ExpBar", current_exp)
	if current_exp >= level_dict[str(level)] and level < 9:
		var leftover: int = current_exp - level_dict[str(level)]
		current_exp = leftover
		on_level_up()
		level += 1
		
		data_management.data_dictionary.current_level = level
		
	elif current_exp >= level_dict[str(level)] and level == 9:
		current_exp = level_dict[str(level)]
		
	data_management.data_dictionary.current_exp = current_exp
	data_management.save_data()
	
	
func on_level_up() -> void:
	current_mana = base_mana + bonus_mana
	current_health = base_health + bonus_health
	
	get_tree().call_group("stats_hud", "update_avaliable_points")
	get_tree().call_group("bar_container", "update_bar", "ManaBar", current_mana)
	get_tree().call_group("bar_container", "update_bar", "HealthBar", current_health)
	
	await get_tree().create_timer(0.2).timeout
	get_tree().call_group("bar_container", "reset_exp_bar", level_dict[str(level)], current_exp)
	
	
func update_health(type: String, value: int) -> void:
	match type:
		"Increase":
			current_health += value
			spawn_floating_text("+", "Heal", value)
			if current_health >= max_health:
				current_health = max_health
				
		"Decrease":
			verify_shield(value)
			if current_health <= 0:
				player.dead = true
			else:
				player.on_hit = true
				player.attacking = false
				
	data_management.data_dictionary.current_health = current_health
	data_management.save_data()
	
	get_tree().call_group("bar_container", "update_bar", "HealthBar", current_health)
				
				
func verify_shield(value: int) -> void:
	if shielding:
		if (base_defense + bonus_defense) >= value:
			return
			
		var damage = abs((base_defense + bonus_defense) - value)
		spawn_floating_text("-", "Damage", damage)
		current_health -= damage
		
	else:
		spawn_floating_text("-", "Damage", value)
		current_health -= value
		
		
func update_mana(type: String, value: int) -> void:
	match type:
		"Increase":
			current_mana += value
			spawn_floating_text("+", "Mana", value)
			if current_mana >= max_mana:
				current_mana = max_mana
				
		"Decrease":
			current_mana -= value
			spawn_floating_text("-", "Mana", value)
			
	data_management.data_dictionary.current_mana = current_mana
	data_management.save_data()
	
	get_tree().call_group("bar_container", "update_bar", "ManaBar", current_mana)
			
			
func update_stats(stat: String) -> void:
	match stat:
		"Attack":
			base_attack += 1
			
		"Mana":
			max_mana += 1
			base_mana += 1
			current_mana += 1
			
			get_tree().call_group("bar_container", "increase_max_value", "Mana", max_mana, current_mana)
			
		"Health":
			max_health += 1
			base_health += 1
			current_health += 1
			
			get_tree().call_group("bar_container", "increase_max_value", "Health", max_health, current_health)
			
		"Magic Attack":
			base_magic_attack += 1
			
		"Defense":
			base_defense += 1
			
	update_stats_hud()
	
	
func update_bonus_stats(stat: String, value: int, reset: bool) -> void:
	match stat:
		"Health":
			if reset:
				bonus_health -= value
			else:
				bonus_health += value
				
			max_health = bonus_health + base_health
			get_tree().call_group("bar_container", "increase_max_value", "Health", max_health, current_health)
			
		"Mana":
			if reset:
				bonus_mana -= value
				
			else:
				bonus_mana += value
				
			max_mana = bonus_mana + base_mana
			get_tree().call_group("bar_container", "increase_max_value", "Mana", max_mana, current_mana)
			
		"Attack":
			if reset:
				bonus_attack -= value
			else:
				bonus_attack += value
				
		"Magic Attack":
			if reset:
				bonus_magic_attack -= value
			else:
				bonus_magic_attack += value
				
		"Defense":
			if reset:
				bonus_defense -= value
			else:
				bonus_defense += value
				
	update_stats_hud()
	
	
func update_stats_hud() -> void:
	get_tree().call_group(
		"stats_hud", 
		"update_stats", 
		[
			base_health, 
			base_mana,
			base_attack,
			base_magic_attack,
			base_defense
		],
		[
			bonus_health,
			bonus_mana,
			bonus_attack,
			bonus_magic_attack,
			bonus_defense
		]
	)
	
	data_management.data_dictionary.base_stats = [
		base_health, 
		base_mana,
		base_attack,
		base_magic_attack,
		base_defense
	]
	
	data_management.save_data()
	
	if current_health > max_health:
		current_health = max_health
			
	if current_mana > max_mana:
		current_mana = max_mana
			
			
func on_collision_area_entered(area):
	if area.name == "EnemyAttackArea":
		update_health("Decrease", area.damage)
		collision_area.set_deferred("monitoring", false)
		invencibility_timer.start(area.invencibility_timer)
		
		
func on_invencibility_timer_timeout() -> void:
	collision_area.set_deferred("monitoring", true)
	
	
func spawn_floating_text(type_sign: String, type: String, value: int) -> void:
	var text: FloatText = floating_text.instantiate()
	text.global_position = player.global_position
	
	text.type = type
	text.value = value
	text.type_sign = type_sign
	
	get_tree().root.call_deferred("add_child", text)
