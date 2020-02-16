extends KinematicBody2D

export (int) var speed = 300
var velocity = Vector2()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

puppet func set_pos_and_motion2(p_pos,p_velocity):
	position=p_pos
	velocity=p_velocity
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	if is_network_master():
		get_input()
	move_and_slide(velocity)

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('player2_down'):
		velocity.y += 1
	if Input.is_action_pressed('player2_up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	if get_tree().get_network_peer()!=null:
		rpc_unreliable("set_pos_and_motion2", position, velocity)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
