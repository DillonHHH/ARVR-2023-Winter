extends Node3D

@export var KeyGhost: Node3D
@export var KeyArea: Area3D
@export var AlignTheKey: Label3D
@export var WinnerText: Label3D
@export var WinnerSoundEffect: AudioStreamPlayer3D
@export var WinnerTextDelay: Timer
@export var GameCloseDelay: Timer

@export var max_angle_difference_degrees: float = 0

var key_currently_monitoring: RigidBody3D


func _process(delta):
	if key_currently_monitoring:
		if abs(rad_to_deg(angle_difference(KeyGhost.global_rotation.y, key_currently_monitoring.global_rotation.y)) - 90) < max_angle_difference_degrees:
			#key_currently_monitoring.queue_free()
			#key_currently_monitoring = null
			winner()
	
func winner():
	KeyGhost.queue_free()
	KeyArea.queue_free()
	AlignTheKey.queue_free()
	WinnerSoundEffect.play()
	WinnerTextDelay.start()
	GameCloseDelay.start()



func _on_key_area_body_entered(body):
	if body.get_node("GrabSpotAmbiguous") is Key:
		key_currently_monitoring = body


func _on_key_area_body_exited(body):
	if body.get_node("GrabSpotAmbiguous") is Key:
		key_currently_monitoring = null


func _on_winner_text_delay_timeout():
	WinnerText.visible = true

func _on_game_close_delay_timeout():
	get_tree().quit()
	


