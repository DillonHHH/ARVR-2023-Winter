extends XRController3D

@export var translational_strength: float = 50
@export var rotational_strength: float = 8

@onready var area: Area3D = $Area3D
@onready var hand_mesh: Node3D = $Hand
@onready var animation_tree: AnimationTree = $Hand/AnimationTree
@onready var xr_origin: XROrigin3D = $".."
@onready var body: XRToolsPlayerBody = $"../XRToolsPlayerBody"

var animation_player: AnimationPlayer
var left_or_right: String
var held_object_spot: GrabSpot
var held_object_point: Node3D
var held_object_body: RigidBody3D
var hand_closed: bool = false
var controller: XRController3D


# Class and variable here for the sake of being able to call actions by doing XRActions.action_name instead of using strings
class XRActionsClass:
	var trigger: String = "trigger"
	var grip: String = "grip"
	var ax_button: String = "ax_button"
	var by_button: String = "by_touch"


var XRActions: XRActionsClass = XRActionsClass.new()

# CURRENT WORK ##########
#
# rpg-7-holster script, have to fix the rotation of rpg
#	when first using arrow keys to rotate, then grabbing rpg out of air 
#
# TO DO #################
#
# remove delta from calculation used to set velocities
#
# verify that ax_button and by_buttons work
#
# make it so that 2 hands can't grab the same point at once
#
# might want to make held object have no collision with player body
#
# implement collision detection with rocket so that it will explode
#
# make rpg spawn rocket on trigger
#
#
#
#
#


func _ready():
	if name == "HandLeft":
		left_or_right = "Left"
		animation_player = $Hand/Hand_Nails_L/AnimationPlayer
	elif name == "HandRight":
		left_or_right = "Right"
		animation_player = $Hand/Hand_Nails_R/AnimationPlayer
	else:
		push_error('No parent controller named "HandLeft" or "HandRight" found!')
	controller = XRTools.find_xr_ancestor(self, "*", "XRController3D")  # Find our controller - taken from Godot XR Tools
	if !controller:
		push_error("No controller for" + left_or_right + " hand found!")


func _process(_delta):
	"yes"
	if get_input("grip_click") && !hand_closed:
		close_hand()
		if (
			area.get_overlapping_areas()
			&& area.get_overlapping_areas().any(func(a): return a is GrabSpot)
		):
			grab(area.get_overlapping_areas().filter(func(a): return a is GrabSpot)[0])  # grab the first grabspot found
	else:
		if hand_closed && !is_button_pressed("grip_click"):
			open_hand()
			if held_object_spot:
				release()		
	# Animate the hand mesh with the controller inputs - taken from Godot XR Tools
	if controller && !held_object_spot:  # if object is held, we should already have an active animation
		var grip: float = controller.get_float(XRActions.grip)
		var trigger: float = controller.get_float(XRActions.trigger)
		animation_tree.set("parameters/Grip/blend_amount", grip)
		animation_tree.set("parameters/Trigger/blend_amount", trigger)
	# --------------------------

	if held_object_spot:
		if controller.get_float(XRActions.trigger):
			held_object_spot._on_trigger()
		if controller.get_input(XRActions.ax_button):
			held_object_spot._on_ax_button()
		if controller.get_input(XRActions.by_button):
			held_object_spot._on_by_button()


func _physics_process(delta):
	if held_object_body:	
		var distance_to_object = global_position - held_object_point.global_position
		var direction_to_move_object = distance_to_object.normalized()
		held_object_body.linear_velocity = body.velocity + (direction_to_move_object * distance_to_object.length() * translational_strength)
		
		held_object_body.angular_velocity = (
			euler_angle_difference_from_quaternions(
				Quaternion().from_euler(global_rotation),
				held_object_body.quaternion
			)
			* rotational_strength
		)

func grab(grab_spot: GrabSpot):
	held_object_spot = grab_spot
	held_object_point = held_object_spot.get_node_or_null("GrabPoint" + left_or_right)
	if !held_object_point:
		push_error("Grab point for " + left_or_right + " hand not found on grab_spot_ambiguous!")
	held_object_body = held_object_spot.get_parent()
	held_object_body.gravity_scale = 0
	if held_object_spot.animation:
		animation_tree.active = false
		animation_player.play(held_object_spot.animation)
	$Hand.reparent(held_object_point, false)
	held_object_spot._on_grip(self)


func release():
	held_object_spot.get_node("GrabPoint" + left_or_right + "/Hand").reparent(self, false)
	held_object_body.gravity_scale = 1
	held_object_spot._on_grip_release()
	held_object_spot = null
	held_object_body = null
	held_object_point = null
	animation_tree.active = true


func close_hand():
	hand_closed = true


func open_hand():
	hand_closed = false


func euler_angle_difference_from_quaternions(quat1: Quaternion, quat2: Quaternion) -> Vector3:
	var diff = quat1 * quat2.inverse()
	diff = diff.normalized().get_euler()
	return Vector3(diff.x, diff.y, diff.z)
