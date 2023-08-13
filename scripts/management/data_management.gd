extends Node

var save_path: String = "user://save.dat"
var initial_position: Vector2 = Vector2(27, 100)

var data_dictionary: Dictionary = {
	"current_exp": 0,
	"current_level": 1,
	
	"current_mana": 10,
	"current_health": 15,
	
	"player_texture": "",
	"player_position": initial_position,
	
	"base_stats": [
		15,
		10,
		1,
		3,
		1
	],
	
	"available_points": 0,
	
	"armor_container": [],
	"weapon_container": [],
	"consumable_container": []
}

func save_data() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_var(data_dictionary)
		file.close()
		
		
func load_data() -> void:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		data_dictionary = file.get_var()
		file.close()
