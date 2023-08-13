extends Control
class_name StatsContainer

@export var animation: AnimationPlayer = null
@export var left_container: TextureRect = null
@export var right_container: TextureRect = null

var is_object_visible: bool = false

func update_stats(stats_list: Array, bonus_stats_list: Array) -> void:
	left_container.update_stats(stats_list, bonus_stats_list)
	
	
func update_bonus_stats(bonus_dict: Dictionary, state: bool) -> void:
	left_container.update_bonus_stats(bonus_dict, state)
	
	
func reset() -> void:
	left_container.reset()
	right_container.reset()
	
	
func update_avaliable_points() -> void:
	right_container.update_avaliable_points(5)
