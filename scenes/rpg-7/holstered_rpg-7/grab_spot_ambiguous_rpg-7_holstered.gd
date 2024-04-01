extends GrabSpotRPG7

var RPG7Holster: Node3D

var hands_grabbing: int = 0

func _ready():
	if !RPG7Holster:
		print("RPG7Holster not assigned at " + str(get_path()))


func _on_grip(hand):
	get_parent().freeze = false
	set_physics_process(true)
	get_parent().reparent(get_tree().root, true)
	get_parent().global_position = hand.global_position + position
	get_parent().global_rotation = hand.global_rotation
	hands_grabbing += 1
	$GrabArea.queue_free()

func _on_grip_release():
	hands_grabbing -= 1
	if hands_grabbing == 0:
		RPG7Holster.spawn_rpg_7()
		get_parent().queue_free()
