extends RigidBody3D

@export_range(500, 2000)
var thrust : float = 1000.0

@export_range(50, 200)
var torque : float = 100.0

var tween = Tween

var is_transitioning : bool = false

func _process(delta: float) -> void:
	if(Input.is_action_pressed("pb_boost")):
		apply_central_force(basis.y * delta * thrust)
		
	if(Input.is_action_pressed("pb_rotate_left")):
		apply_torque(Vector3(0, 0, torque * delta))
	
	if(Input.is_action_pressed("pb_rotate_right")):
		apply_torque(Vector3(0, 0, -torque * delta))

func _on_body_entered(body: Node) -> void:
	if "Goal" in body.get_groups() and !is_transitioning:
		complete_level(body.next_level)
		is_transitioning = true
	else:
		if "Hazard" in body.get_groups() and !is_transitioning:
			crash_sequence()
			is_transitioning = true
 
func crash_sequence() -> void: 
	print("Absolutely smacked")
	set_process(false)
	tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(get_tree().reload_current_scene)
	
func complete_level(next_level : String) -> void:
	print("Landed safely!!")
	tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind(next_level)
	)
	
	
	
	
