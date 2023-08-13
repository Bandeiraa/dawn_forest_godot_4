extends CanvasLayer

const DIALOG_CONTAINER: PackedScene = preload("res://scenes/interface/general/dialog_container.tscn")

@onready var equipment_container: Control = get_node("EquipmentContainer")
@onready var inventory_container: Control = get_node("InventoryContainer")
@onready var stats_container: Control = get_node("StatsContainer")
@onready var bar_container: Control = get_node("BarContainer")

var can_show_container: bool = true

func _process(_delta: float) -> void:
	if can_show_container:
		show_inventory()
		show_stats()
		
		
func show_inventory() -> void:
	if Input.is_action_just_pressed("inventory"):
		hide_equipment_container()
		
		inventory_container.is_object_visible = !inventory_container.is_object_visible
		if inventory_container.is_object_visible:
			inventory_container.animation.play("show_container")
		else:
			inventory_container.reset()
			inventory_container.animation.play("hide_container")
			equipment_container.animation.play("show_container")
			
		if stats_container.is_object_visible:
			stats_container.reset()
			stats_container.is_object_visible = false
			stats_container.animation.play("hide_container")
			
			
func show_stats() -> void:
	if Input.is_action_just_pressed("stats"):
		hide_equipment_container()
		
		stats_container.is_object_visible = !stats_container.is_object_visible
		if stats_container.is_object_visible:
			stats_container.animation.play("show_container")
		else:
			stats_container.reset()
			stats_container.animation.play("hide_container")
			equipment_container.animation.play("show_container")
			
		if inventory_container.is_object_visible:
			inventory_container.reset()
			inventory_container.is_object_visible = false
			inventory_container.animation.play("hide_container")
			
			
func hide_containers() -> void:
	can_show_container = false
	for node in get_children():
		if node.visible and (node.is_in_group("bar_container") or node.is_in_group("equipment_container")):
			node.animation.play("hide_container")
		elif node.visible:
			node.animation.play("hide_container")
			node.reset()
			
			
func normal_state() -> void:
	can_show_container = true
	bar_container.animation.play("show_container")
	equipment_container.animation.play("show_container")
	
	
func hide_equipment_container() -> void:
	equipment_container.animation.play("hide_container")
	
	
func spawn_dialog(interactable, dialog_list: Dictionary) -> void:
	var dialog = DIALOG_CONTAINER.instantiate()
	dialog.connect("finished", Callable(interactable, "on_dialog_finished"))
	dialog.dialog_list = dialog_list
	add_child(dialog)
