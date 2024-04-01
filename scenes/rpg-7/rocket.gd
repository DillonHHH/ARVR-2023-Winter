extends RigidBody3D
class_name rpg_rocket

## A rocket that will automatically fly in the direction it is facing
## custom_integrator is disabled
## continuous collision detection is enabled

@export var speed: float = 1
@export var explosion_radius: float = .5
@export var lifetime: float = 10
@export var explosive_power: float = 10
@export var ExplosionSound: AudioStreamPlayer3D

@onready var DetectionShapeCast: ShapeCast3D = $DetectionShapeCast
@onready var ExplosionShapeCast: ShapeCast3D = $ExplosionShapeCast
@onready var LifetimeTimer: Timer = $LifetimeTimer

var _no_collide: Array[Node3D]
var params_set: bool = false
var _starting_rotation # used to lock rotation, Lock Rotation property only prevents rotation by physics

func _ready(): 
	if !params_set: # throw error if scene is added to tree and parameters haven't been set
		push_error("PARAMETERS NOT SET FOR ROCKET: " + str(get_path()))
	ExplosionShapeCast.shape.radius = explosion_radius
	LifetimeTimer.start(lifetime)
	

func set_params(no_collide: Array[Node3D], starting_position: Vector3, starting_rotation: Vector3):
	_no_collide = no_collide
	_no_collide.append($".")
	position = starting_position
	rotation = starting_rotation
	_starting_rotation = starting_rotation
	params_set = true


func _physics_process(delta):
	rotation = _starting_rotation
	linear_velocity = -transform.basis.z * speed
	DetectionShapeCast.force_shapecast_update()
	if DetectionShapeCast.collision_result && !DetectionShapeCast.collision_result.any(func(result): return _no_collide.has(result.collider)):
		detonate()
	
func detonate():
	ExplosionSound.play_and_free()
	ExplosionShapeCast.force_shapecast_update()
	for result in ExplosionShapeCast.collision_result:
		if (result.collider.has_method("receive_explosion")):
			result.collider.receive_explosion(self, explosive_power)
		elif result.collider.get_parent().has_method("receive_explosion"):
			result.collider.get_parent().receive_explosion(self, explosive_power)
	queue_free()

func _on_lifetime_timer_timeout():
	detonate() 
