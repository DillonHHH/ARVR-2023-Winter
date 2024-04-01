extends Node3D

@export var rpg_7_holstered: PackedScene

func _ready():
	if !rpg_7_holstered:
		push_error("rpg_7_holstered not set at " + str(get_path()))
	spawn_rpg_7()


func _process(_delta):
	#global_position = $"../XRCamera3D".global_position + Vector3(-.1, -.2, .2)
	global_position.y = $"../../XRCamera3D".global_position.y + -.2


	
func spawn_rpg_7():
	var rpg_7: Node3D = rpg_7_holstered.instantiate()
	rpg_7.get_child(0).RPG7Holster = self
	rpg_7.freeze = true
	add_child(rpg_7)
	
