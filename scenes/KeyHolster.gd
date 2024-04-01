extends Node3D

@export var key: PackedScene

var has_key: bool = false

func _process(_delta):
	#global_position = $"../XRCamera3D".global_position + Vector3(-.2, -.5, 0)
	global_position.y = $"../../XRCamera3D".global_position.y + -.5
	
	
func spawn_key():
	if has_key:
		var new_key: Node3D = key.instantiate()
		new_key.get_node("GrabSpotAmbiguous").KeyHolster = self
		new_key.freeze = true
		add_child(new_key)
