extends TextureRect
class_name ArmorContainer

@onready var armor_item: TextureRect = get_node("Item")

var armor_dictionary: Dictionary = {}
var armor_name: String = ""
var armor_type: String = ""
var armor_texture_path: String = ""

var armor_price: int

func _ready() -> void:
	if FileAccess.file_exists(data_management.save_path):
		data_management.load_data()
		
		if data_management.data_dictionary.armor_container.is_empty():
			return
			
		var data: Array = data_management.data_dictionary.armor_container
		var item_texture: CompressedTexture2D = load(data[0])
		update_armor_slot(item_texture, data)
		
		
func update_armor_slot(item_texture: CompressedTexture2D, item_info: Array) -> void:
	if armor_name != "":
		get_tree().call_group(
			"inventory",
			"update_slot",
			armor_name,
			armor_item.texture,
			[
				armor_texture_path,
				armor_type,
				armor_dictionary,
				armor_price,
				1
			]
		)
		
		reset()
		
	armor_item.texture = item_texture
	armor_texture_path = item_info[0]
	armor_name = item_info[1]
	armor_type = item_info[2]
	armor_dictionary = item_info[3]
	armor_price = item_info[4]
	
	armor_item.show()
	
	get_tree().call_group("stats_hud", "update_bonus_stats", armor_dictionary, false)
	data_management.data_dictionary.armor_container = item_info
	data_management.save_data()
	
	
func reset() -> void:
	armor_name = ""
	armor_type = ""
	armor_texture_path = ""
	
	armor_price = 0
	armor_item.texture = null
	
	armor_dictionary = {}
	data_management.data_dictionary.armor_container = []
	data_management.save_data()
