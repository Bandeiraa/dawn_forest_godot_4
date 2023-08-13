extends TextureRect
class_name WeaponContainer

@onready var weapon_item: TextureRect = get_node("Item")

var weapon_dictionary: Dictionary = {}
var weapon_name: String = ""
var weapon_type: String = ""
var weapon_texture_path: String = ""

var weapon_price: int

func _ready() -> void:
	if FileAccess.file_exists(data_management.save_path):
		data_management.load_data()
		
		if data_management.data_dictionary.weapon_container.is_empty():
			return
			
		var data: Array = data_management.data_dictionary.weapon_container
		var item_texture: CompressedTexture2D = load(data[0])
		update_weapon_slot(item_texture, data)
		
		
func update_weapon_slot(item_texture: CompressedTexture2D, item_info: Array) -> void:
	if weapon_name != "":
		get_tree().call_group(
			"inventory",
			"update_slot",
			weapon_name,
			weapon_item.texture,
			[
				weapon_texture_path,
				weapon_type,
				weapon_dictionary,
				weapon_price,
				1
			]
		)
		
		reset()
		
	weapon_item.texture = item_texture
	weapon_texture_path = item_info[0]
	weapon_name = item_info[1]
	weapon_type = item_info[2]
	weapon_dictionary = item_info[3]
	weapon_price = item_info[4]
	
	weapon_item.show()
	
	get_tree().call_group("stats_hud", "update_bonus_stats", weapon_dictionary, false)
	data_management.data_dictionary.weapon_container = item_info
	data_management.save_data()
	
	
	
func reset() -> void:
	weapon_name = ""
	weapon_type = ""
	weapon_texture_path = ""
	
	weapon_price = 0
	weapon_item.texture = null
	
	#Resetar os stats bônus da arma equipada anteriormente
	weapon_dictionary = {}
	
	data_management.data_dictionary.weapon_container = []
	data_management.save_data()
