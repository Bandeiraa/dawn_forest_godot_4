extends Node2D
class_name Level

@onready var player: CharacterBody2D = get_node("Player")

@export var scene_path: String

func _ready() -> void:
	var _game_over: bool = player.get_node("Texture2D").connect("game_over", Callable(self, "on_game_over"))
	data_management.load_data()
	
	player.global_position = data_management.data_dictionary.player_position
	
	
func on_game_over() -> void:
	data_management.data_dictionary.base_stats = [
		15,
		10,
		1,
		3,
		1
	]
	
	data_management.data_dictionary.current_exp = 0
	data_management.data_dictionary.current_level = 1
	data_management.data_dictionary.current_mana = 10
	data_management.data_dictionary.current_health = 15
	data_management.data_dictionary.player_position = data_management.initial_position
	
	data_management.data_dictionary.consumable_container = []
	data_management.data_dictionary.weapon_container = []
	data_management.data_dictionary.armor_container = []
	data_management.save_data()
	
	transition_screen.scene_path = scene_path
	transition_screen.fade_in()
