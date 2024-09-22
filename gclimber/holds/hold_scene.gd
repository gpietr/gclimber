extends Node2D

class_name Hold
@onready var line = $Line2D

var hold_quality = 100

func _ready() -> void:
	pass # Replace with function body.

func mark_active(distance: float) -> void:
	line.default_color = Color.RED
	
func mark_inactive() -> void:
	line.default_color = Color.WHITE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_center_position() -> Vector2:
	var center = Vector2(0, 0)
	return global_position + center
