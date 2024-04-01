extends XROrigin3D

# these do nothing:
#@export var gravity: float = -25 #-9.8 m/s normal grav
#@export var move_speed: float = 1000.0
#@export var jump_speed: float = 25.0

@onready var body: XRToolsPlayerBody = $XRToolsPlayerBody
@onready var camera: XRCamera3D = $XRCamera3D

var key_parts_collected = 0

func _ready():
	pass

func _process(delta: float) -> void:
	pass
	
func add_key_part():
	key_parts_collected += 1
	if key_parts_collected >= 3:
		add_key()
	
func add_key():
	$XRToolsPlayerBody/KeyHolster.has_key = true
	$XRToolsPlayerBody/KeyHolster.spawn_key()
	
func receive_explosion(source: Node3D, power: float):
	# The following is used to fine tune the direction the player flies according
	# 	according to the posiiton and type of nearby explosions
	var ExplosionPosition: Node3D
	if source.is_class("rpg_rocket"):
		ExplosionPosition = $RocketExplosionPosition
	else: 
		ExplosionPosition = $SatchelExplosionPosition
	var distance_to_source: float = ExplosionPosition.global_position.distance_to(source.global_position)
	source.look_at(ExplosionPosition.global_position)
	body.velocity += (ExplosionPosition.global_position - source.global_position).normalized() * clamp(3.5 - (distance_to_source/2)**2, 0, 3.5) * power
	if body.velocity.x > 25:
		body.velocity.x = 25
	if body.velocity.y > 25:
		body.velocity.y = 25
	if body.velocity.z > 25:
		body.velocity.z = 25


func _on_key_collection_area_area_entered(area):
	if area.get_parent() is KeyPiece:
		add_key_part()
		area.get_parent().on_pickup()
		
