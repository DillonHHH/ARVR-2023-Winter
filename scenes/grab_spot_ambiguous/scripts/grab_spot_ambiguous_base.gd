extends Area3D
class_name GrabSpot

@export_enum("Cup", "Default pose", "Grip", "Grip 1", "Grip 2", "Grip 3", "Grip 4", "Grip 5", "Grip Shaft", "Hold", "Horns", "Metal", "Middle", "OK", "Peace", "Pinch Flat", "Pinch Large", "Pinch Middle", "Pinch Ring", "Pinch Tight", "Pinch Up", "PingPong", "Pinky", "Pistol", "Ring", "Rounded", "Sign 1", "Sign 2", "Sign 3", "Sign 4", "Sign 5", "Sign_Point", "Straight", "Surfer", "Thumb") var animation : String = "Default pose"
	
func _ready():
	pass

func _on_grip(hand: Node3D):
	pass
	
func _on_grip_release():
	pass
	
func _on_trigger():
	pass

func _on_trigger_release():
	pass
	
func _on_ax_button():
	pass

func _on_ax_button_release():
	pass
	
func _on_by_button():
	pass

func _on_by_button_release():
	pass
