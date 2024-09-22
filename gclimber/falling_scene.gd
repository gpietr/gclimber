extends Node2D

@onready var restart_button = $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	restart_button.pressed.connect(self.restart)
	pass # Replace with function body.

func restart() -> void:
	get_tree().change_scene_to_file("res://game_scene.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
