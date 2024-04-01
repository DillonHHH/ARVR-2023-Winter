@tool
extends Node3D

func _ready():
	if (!Engine.is_editor_hint()):
		push_warning("HAND PREVIEW NODE AT PATH \n\t" + str(get_path()) + "\n\t IS FOR EDITOR USE ONLY, AND SHOULD NOT BE INCLUDED IN THE FINAL BUILD")


func _process(_delta):
	# put extra debug code here
	
	
	
	###
	var left_hand : Node3D = get_node_or_null("HandL")
	var right_hand : Node3D = get_node_or_null("HandR")
	var grab_point_left : Node3D = get_node_or_null("../GrabPointLeft")
	var grab_point_right : Node3D = get_node_or_null("../GrabPointRight")
	var left_hand_animationplayer: AnimationPlayer = left_hand.get_node_or_null("AnimationPlayer")
	var right_hand_animationplayer: AnimationPlayer = right_hand.get_node_or_null("AnimationPlayer")
	var animation : String 
	animation = get_parent().animation
	
	if(left_hand):
		if(left_hand_animationplayer && animation):
			left_hand.get_node("AnimationPlayer").play(animation)
		if(grab_point_left):
			left_hand.global_position=grab_point_left.global_position
			left_hand.global_rotation=grab_point_left.global_rotation
			if(grab_point_left.is_visible()):
				left_hand.visible = true
			else:
				left_hand.visible = false
	if(right_hand):
		if(right_hand_animationplayer && animation):
			right_hand.get_node("AnimationPlayer").play(animation)
		if(grab_point_right):
			right_hand.global_position=grab_point_right.global_position
			right_hand.global_rotation=grab_point_right.global_rotation
			if(grab_point_right.is_visible()):
				right_hand.visible = true
			else:
				right_hand.visible = false

