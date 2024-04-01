extends MeshInstance3D

@export var rotation_speed: float = .5

func _process(delta):
	rotation.y += 2 * rotation_speed * delta

