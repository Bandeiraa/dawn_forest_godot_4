extends Area2D
class_name CollisionArea

@onready var timer: Timer = get_node("Timer")

@export var health: int
@export var invulnerability_timer: float

@export var enemy: CharacterBody2D = null
@export var enemy_bar: Control = null

func _ready() -> void:
	enemy_bar.init_bar(health)
	
	
func on_collision_area_entered(area):
	if not area.name == "AttackArea":
		return
		
	print(area.name)
	if area.get_parent() is Player:
		var player_stats: Node = area.get_parent().get_node("Stats")
		var player_attack: int = player_stats.base_attack + player_stats.bonus_attack
		update_health(player_attack)
	elif area is FireSpell:
		update_health(area.spell_damage)
		set_deferred("monitoring", false)
		timer.start(invulnerability_timer)
		
		
func update_health(damage: int) -> void:
	health -= damage
	enemy_bar.update_bar(health)
	enemy.spawn_floating_text("-", "Damage", damage)
	
	if health <= 0:
		enemy.can_die = true
		return
		
	enemy.can_hit = true


func on_timer_timeout():
	set_deferred("monitoring", true)
