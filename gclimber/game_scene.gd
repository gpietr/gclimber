extends Node2D

@onready var climber = $Climber
@onready var holds = $holds
@onready var energy_bar = $EnergyBar
@onready var current_hold_status = $CurrentHoldStatus
@onready var target_hold_status = $TargetHoldStatus

var total_energy = 100
var current_energy = total_energy
var climber_height = 100
var max_dyno = 100

var update_energy_interval = 0.5

var timer_update_energy = Timer.new()

func _ready() -> void:
	add_child(timer_update_energy)
	update_energy_bar()
	var starting_hold = holds.get_children()[0]
	bring_climber_to_hold(starting_hold)
	timer_update_energy.wait_time = update_energy_interval
	timer_update_energy.one_shot = false
	timer_update_energy.connect("timeout", update_energy)
	timer_update_energy.start()
	
	
func update_energy() -> void:
	var cost = (100 - currentHold.hold_quality)/100.0
	var hold_quality = currentHold.hold_quality
	current_energy -= cost
	update_energy_bar()
	queue_redraw()	

func update_energy_bar() -> void:
	energy_bar.value = current_energy
	if current_energy <= 0:
		get_tree().change_scene_to_file("res://falling_scene.tscn")


func bring_climber_to_hold(hold: Hold) -> void:
	climber.position.y = hold.position.y + 50
	climber.position.x = hold.position.x
	if currentHold is Hold:
		current_energy -= calculate_move_effort(hold)
		update_energy_bar()
	currentHold = hold
	current_hold_status.text = "Hold quality: " + str(currentHold.hold_quality)

func minBy(arr, func_get_value: Callable):
	if arr.size() == 0:
		return null  # or you can return a default value or raise an error

	var min_element = arr[0]
	var min_value = func_get_value.call(min_element)
	
	for element in arr:
		var value = func_get_value.call(element)
		if value < min_value:
			min_value = value
			min_element = element
			
	return min_element

var activeTargetHold: Hold
var currentHold: Hold

func calculate_move_effort(hold: Hold) -> float:
	var distance = hold.get_center_position().distance_to(currentHold.get_center_position())
	if distance < climber_height:
		return 1
	if distance == climber_height:
		return 1.5
	if distance > climber_height + max_dyno:
		return 100
	return pow(2, distance / climber_height)

func mark_hold_active_target(hold: Hold) -> void:
	var distance = hold.get_center_position().distance_to(currentHold.get_center_position())
	hold.mark_active(distance)
	var effort = calculate_move_effort(hold)
	target_hold_status.text = "Effort: " + "%.01f" % effort + "; Quality: " + str(hold.hold_quality)

func _process(delta: float) -> void:
	var mousePosition = get_global_mouse_position()
	var allHolds = holds.get_children()
	var firstCenter = allHolds[0].get_center_position()
	var closestHold = minBy(allHolds, func(h): return h.get_center_position().distance_to(mousePosition))
	
	if activeTargetHold != closestHold:
		if activeTargetHold is Hold:
			activeTargetHold.mark_inactive()
		mark_hold_active_target(closestHold)
		activeTargetHold = closestHold
		queue_redraw()
		
	if Input.is_action_just_released("MousePress"):
		if activeTargetHold is Hold:
			bring_climber_to_hold(activeTargetHold)
		queue_redraw()	
