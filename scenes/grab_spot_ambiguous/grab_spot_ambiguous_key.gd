extends GrabSpot

class_name Key

var hands_grabbing: int = 0

var KeyHolster: Node3D


func _ready():
	if !KeyHolster:
		push_error("KeyHolster not set at " + str(get_path()))
		
		
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
		KeyHolster.spawn_key()
		get_parent().queue_free()
