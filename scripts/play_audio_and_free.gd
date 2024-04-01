extends AudioStreamPlayer3D

var free_after_playing: bool = false

func play_and_free():
	play()
	reparent(get_tree().root, true)
	free_after_playing = true

func _on_finished():
	if free_after_playing:
		queue_free()
