extends AnimatableBody3D

@export var destination: Vector3
@export var return_position: Vector3
@export var duration: float = 2

func _ready() -> void:
	var tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", global_position + destination, duration)
	tween.tween_interval(1.0)
	tween.tween_property(self, "global_position", global_position, duration)
	tween.tween_interval(1.0)
	
	
func move_up() -> void:
	var tween = create_tween()
	
	tween.tween_callback(move_down)
	
func move_down() -> void:
	var tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(move_up)
