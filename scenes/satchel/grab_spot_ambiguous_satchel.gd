extends GrabSpot

class_name Satchel

@export var timer: Timer

@onready var ExplosionShapeCast: ShapeCast3D = $"../ExplosionShapeCast"
@export var explosion_radius: float = 1
@export var explosive_power: float = 5
@export var ExplosionSound: AudioStreamPlayer3D

var SatchelHolster: Node3D
var hands_grabbing: int = 0

func _ready():
	if !SatchelHolster:
		print("SatchelHolster not assigned at " + str(get_path()))


func _on_grip(hand):
	get_parent().freeze = false
	set_physics_process(true)
	get_parent().reparent(get_tree().root, true)
	get_parent().global_position = hand.global_position + position
	get_parent().global_rotation = hand.global_rotation
	hands_grabbing += 1

func _on_grip_release():
	$GrabArea.queue_free()
	hands_grabbing -= 1
	if hands_grabbing == 0:
		SatchelHolster.spawn_satchel()
		timer.start()
	

func _on_timer_timeout():
	detonate()


func detonate():
	ExplosionSound.play_and_free()
	ExplosionShapeCast.force_shapecast_update()
	for result in ExplosionShapeCast.collision_result:
		if (result.collider.has_method("receive_explosion")):
			result.collider.receive_explosion($"..", explosive_power)
		elif result.collider.get_parent().has_method("receive_explosion"):
			result.collider.get_parent().receive_explosion($"..", explosive_power)
	get_parent().queue_free()
	queue_free()
