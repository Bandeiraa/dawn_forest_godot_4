extends TextureRect
class_name StatsRightContainer

var stats_points: int = 0

@export var v_container: VBoxContainer = null
@export var points_info: TextureRect = null

func _ready() -> void:
	if FileAccess.file_exists(data_management.save_path):
		data_management.load_data()
		stats_points = data_management.data_dictionary.available_points
		
	points_info.update_text_value(str(stats_points))
	for children in v_container.get_children():
		var button: TextureButton = children.get_node("Plus")
		var _pressed: bool = button.connect("pressed", Callable(self, "verify_stat").bind(children.name))
		var _exited: bool = button.connect("mouse_exited", Callable(self, "mouse_interaction").bind("exited", button))
		var _entered: bool = button.connect("mouse_entered", Callable(self, "mouse_interaction").bind("entered", button))
		
		
func mouse_interaction(type: String, container) -> void:
	match type:
		"entered":
			container.modulate.a = 0.5
			points_info.play_animation("show_container")
			
		"exited":
			container.modulate.a = 1.0
			points_info.play_animation("hide_container")
			
			
func verify_stat(stat: String) -> void:
	match stat:
		"HealthContainer":
			apply_weight(1, "Health")
			
		"ManaContainer":
			apply_weight(1, "Mana")
			
		"AttackContainer":
			apply_weight(3, "Attack")
			
		"MagicAttackContainer":
			apply_weight(3, "Magic Attack")
			
		"DefenseContainer":
			apply_weight(5, "Defense")
			
			
func apply_weight(weight: int, stat: String) -> void:
	if stats_points >= weight:
		stats_points -= weight
		points_info.update_text_value(str(stats_points))
		get_tree().call_group("player_stats", "update_stats", stat)
		
		data_management.data_dictionary.available_points = stats_points
		data_management.save_data()
		
		
func reset() -> void:
	for children in v_container.get_children():
		var button: TextureButton = children.get_node("Plus")
		if button.modulate.a != 1.0:
			button.modulate.a = 1.0
			points_info.play_animation("hide_container")
			
			
func update_avaliable_points(value: int) -> void:
	stats_points += value
	points_info.update_text_value(str(stats_points))
	data_management.data_dictionary.available_points = stats_points
	data_management.save_data()
