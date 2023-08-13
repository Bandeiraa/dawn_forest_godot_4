extends Control

@onready var menu: Control = get_node("Menu")
@onready var button_container: VBoxContainer = menu.get_node("ButtonContainer")
@onready var continue_button: Button = button_container.get_node("Continue")

@onready var skin_select: Control = get_node("SkinSelect")

func _ready() -> void:
	for button in get_tree().get_nodes_in_group("button"):
		button.connect("pressed", Callable(self, "on_button_pressed").bind(button.name))
		button.connect("mouse_exited", Callable(self, "mouse_interaction").bind(button, "exited"))
		button.connect("mouse_entered", Callable(self, "mouse_interaction").bind(button, "entered"))
		
	has_save()
	
	
func has_save() -> void:
	if FileAccess.file_exists(data_management.save_path):
		continue_button.disabled = false
		return
		
	continue_button.modulate.a = 0.5
	
	
func on_button_pressed(button_name: String) -> void:
	match button_name:
		"Play":
			button_container.hide()
			skin_select.show()
			
		"Continue":
			transition_screen.scene_path = "res://scenes/management/level.tscn"
			transition_screen.fade_in()
			
		"Quit":
			get_tree().quit()
			
		"BackButton":
			skin_select.hide()
			button_container.show()
			
		"Red":
			send_skin_and_start_game("res://assets/player/char_red.png")
			
		"Blue":
			send_skin_and_start_game("res://assets/player/char_blue.png")
			
		"Green":
			send_skin_and_start_game("res://assets/player/char_green.png")
			
		"Purple":
			send_skin_and_start_game("res://assets/player/char_purple.png")
		
	reset()
	
	
func mouse_interaction(button: Button, type: String) -> void:
	if button.disabled:
		return
		
	match type:
		"exited":
			button.modulate.a = 1.0
			
		"entered":
			button.modulate.a = 0.5
			
			
func reset() -> void:
	for button in get_tree().get_nodes_in_group("button"):
		mouse_interaction(button, "exited")
		
		
func send_skin_and_start_game(skin: String) -> void:
	data_management.data_dictionary.player_texture = skin
	
	transition_screen.scene_path = "res://scenes/management/level.tscn"
	transition_screen.fade_in()
	
	data_management.save_data()
