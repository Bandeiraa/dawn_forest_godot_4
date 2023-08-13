extends Node2D
class_name EnemySpawner

@onready var spawn_timer: Timer = get_node("Timer")

var enemy_count: int = 0

@export var enemies_list: Array

@export var spawn_cooldown: float

@export var enemy_amount: int
@export var left_gap_position: int
@export var right_gap_position: int

@export var can_respawn: bool

func _ready() -> void:
	randomize()
	spawn_enemy()
	
	
func spawn_enemy() -> void:
	enemy_count += 1
	var random_number: int = randi() % 100 + 1
	for enemy in enemies_list:
		if enemy[2] <= random_number and enemy[3] >= random_number:
			var enemy_instance = load(enemy[0]).instantiate()
			enemy_instance.connect("kill", Callable(self, "on_enemy_killed"))
			enemy_instance.global_position = Vector2(spawn_position(), enemy[1])
			add_child(enemy_instance)
			
	if enemy_count < enemy_amount:
		spawn_timer.start(spawn_cooldown)
		
		
func spawn_position() -> float:
	return randf_range(left_gap_position, right_gap_position)
	
	
func on_enemy_killed() -> void:
	enemy_count -= 1
	spawn_timer.start(spawn_cooldown)
	
	
func on_spawner_timeout() -> void:
	if can_respawn:
		spawn_enemy()
