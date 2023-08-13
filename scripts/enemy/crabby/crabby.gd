extends EnemyTemplate
class_name Crabby

func _ready() -> void:
	randomize()
	drop_list = {
		"Heal Potion": [
			"res://assets/item/consumable/health_potion.png",
			15,
			"Health",
			5,
			2
		],
		
		"Mana Potion": [
			"res://assets/item/consumable/mana_potion.png",
			8,
			"Mana",
			5,
			5
		],
		
		"Crabby Eye": [
			"res://assets/item/resource/crabby/crab_eye.png",
			35,
			"Resource",
			{},
			3
		],
		
		"Crabby Pincers": [
			"res://assets/item/resource/crabby/crab_pincers.png",
			10,
			"Resource",
			{},
			7
		],
		
		"Crabby Belt": [
			"res://assets/item/equipment/crabby_belt.png",
			5,
			"Equipment",
			{
				"Health": 3,
				"Attack": 1
			},
			30
		],
		
		"Crabby Axe": [
			"res://assets/item/equipment/crabby_axe.png",
			2,
			"Weapon",
			{
				"Attack": 3,
				"Defense": 1
			},
			40
		]
	}
