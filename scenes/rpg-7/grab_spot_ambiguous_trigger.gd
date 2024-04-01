extends GrabSpot
class_name GrabSpotRPG7

@onready var FiringDelayTimer: Timer = $"../FiringDelayTimer"

@export var rocket: PackedScene
@export var firing_delay: float = 1

func _ready():
	FiringDelayTimer.wait_time = 0.00001 # timer starts at 0
	FiringDelayTimer.start()
	if !rocket:
		print("rocket not assigned at " + str(get_path()))
		
func _on_trigger():
	if FiringDelayTimer.time_left == 0:
		FiringDelayTimer.start(firing_delay)
		var newRocket: rpg_rocket = rocket.instantiate()
		newRocket.set_params([$".."], $"../SpawnPositionRocket".global_position, $"../SpawnPositionRocket".global_rotation)
		get_tree().root.add_child(newRocket)
