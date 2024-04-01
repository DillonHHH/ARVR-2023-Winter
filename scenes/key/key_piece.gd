extends MeshInstance3D

class_name KeyPiece

@export var SoundEffect: AudioStreamPlayer3D
@export var rotation_speed: float = .5

func _ready():
	if !SoundEffect:
		push_error("No SoundEffect set at " + str(get_path()))

func _process(delta):
	rotation.x += 1 * rotation_speed * delta
	rotation.y += 2 * rotation_speed * delta
	rotation.z += 3 * rotation_speed * delta
	
func on_pickup():
	SoundEffect.play_and_free()
	queue_free()
