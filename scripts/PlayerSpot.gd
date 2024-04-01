extends MeshInstance3D

@export var player_camera: Node3D

func _process(_delta):
	global_position.x = player_camera.global_position.x
	global_position.z = player_camera.global_position.z
