extends RigidBody3D

@export_range(500, 2000)
var thrust : float = 1000.0

@export_range(50, 200)
var torque : float = 100.0

var tween = Tween

var is_transitioning : bool = false

@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var victory_audio: AudioStreamPlayer = $VictoryAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var booster_particles_left: GPUParticles3D = $BoosterParticlesLeft
@onready var booster_particles_right: GPUParticles3D = $BoosterParticlesRight
@onready var success_particles: GPUParticles3D = $SuccessParticles
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles


func _process(delta: float) -> void:
	if(Input.is_action_pressed("pb_boost")):
		apply_central_force(basis.y * delta * thrust)
		booster_particles.emitting = true
		if(rocket_audio.playing == false):
			rocket_audio.play()
	else:
		rocket_audio.stop()
		booster_particles.emitting = false
		
	if(Input.is_action_pressed("pb_rotate_left")):
		apply_torque(Vector3(0, 0, torque * delta))
		booster_particles_right.emitting = true
	else:
		booster_particles_right.emitting = false
			
	if(Input.is_action_pressed("pb_rotate_right")):
		apply_torque(Vector3(0, 0, -torque * delta))
		booster_particles_left.emitting = true
	else:
		booster_particles_left.emitting = false

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
	explosion_audio.play()
	explosion_particles.emitting = true
	set_process(false)
	tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(get_tree().reload_current_scene)
	
func complete_level(next_level : String) -> void:
	print("Landed safely!!")
	victory_audio.play()
	success_particles.emitting = true
	tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind(next_level)
	)
	
	
	
	
