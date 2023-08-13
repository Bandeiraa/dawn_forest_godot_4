extends Control

signal finished

@onready var timer: Timer = get_node("Timer")
@onready var animation: AnimationPlayer = get_node("Animation")

@onready var label_name: Label = get_node("Background/Name")
@onready var portrait: TextureRect = get_node("Background/Portrait")
@onready var text_label: RichTextLabel = get_node("Background/TextLabel")

var can_skip_dialog: bool = false

var dialog_size: int
var dialog_index: int = 0

var dialog_list: Dictionary = {
	"dialog": [
		"Ola, aventureiro, Em que posso te ajudar?, Em que posso te ajudar?, Em que posso te ajudar?",
		"Em que posso te ajudar?"
	],
	
	"portrait": null,
	"name": ""
}

@export var wait_time: float = 0.02

func _ready() -> void:
	animation.play("fade_in")
	dialog_size = dialog_list["dialog"].size()
	
	if dialog_list["portrait"] != null:
		label_name.text = dialog_list["name"]
		text_label.position = Vector2(47, 24)
		portrait.texture = load(dialog_list["portrait"])
		
	show_dialog()
	
	
func _process(_delta) -> void:
	if Input.is_action_just_pressed("interact") and can_skip_dialog:
		can_skip_dialog = false
		show_dialog()
		
		
func show_dialog() -> void:
	if dialog_index == dialog_size:
		animation.play("fade_out")
		await animation.animation_finished
		emit_signal("finished")
		queue_free()
		return
		
	text_label.percent_visible = 0
	text_label.text = dialog_list["dialog"][dialog_index]
	
	dialog_index += 1
	
	while text_label.visible_characters < len(text_label.text):
		text_label.visible_characters += 1
		timer.start(wait_time)
		await timer.timeout
		
	can_skip_dialog = true
