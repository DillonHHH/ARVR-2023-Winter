extends Node3D

@export var satchel: PackedScene

func _ready():
	if !satchel:
		push_error("satchel not set at " + str(get_path()))
	spawn_satchel()
	
	
func _process(_delta):
	#global_position = $"../XRCamera3D".global_position + Vector3(-.2, -.5, 0)
	global_position.y = $"../../XRCamera3D".global_position.y + -.5

func spawn_satchel():
	var satchel: Node3D = satchel.instantiate()
	satchel.get_child(0).SatchelHolster = self
	satchel.freeze = true
	add_child(satchel)
	
