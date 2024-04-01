extends RigidBody3D

@onready var world = $".."
@onready var starting_height = global_position.y

func _ready():
	axis_lock_linear_x = true
	axis_lock_linear_z = true
	
func _process(delta):
	$"../shader mesh".set_instance_shader_parameter("strength",  (global_position.y - starting_height) * 5)
