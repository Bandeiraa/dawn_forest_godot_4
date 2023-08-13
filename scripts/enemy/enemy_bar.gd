extends Control
class_name EnemyHealthBar

@onready var health_bar: TextureProgressBar = get_node("BarBackground/HealthBar")

var current_health: int

func init_bar(bar_value: int) -> void:
	await get_parent().ready
	
	health_bar.max_value = bar_value
	health_bar.value = bar_value
	current_health = bar_value
	
	
func update_bar(value: int) -> void:
	call_tween(value)
	current_health = value
	
	
func call_tween(new_value: int) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(
		health_bar,
		"value",
		new_value,
		0.4
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
