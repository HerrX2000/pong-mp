extends KinematicBody2D
# Declare member variables here. Examples:
# var a = 2
var screen_size
var direction = Vector2(1.0, 0.0)
const INITIAL_SPEED = 5
# Speed of the ball (also in pixels/second)
var speed = INITIAL_SPEED
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_network_master():
		start_ball()

puppet func set_pos_and_motion_ball(b_pos,b_vol):
	position=b_pos
	velocity=b_vol

func _physics_process(delta):
	if is_network_master():
		var collision_info = move_and_collide(velocity*(speed+(1+GLOBAL.game_nmb/5)))
		if collision_info:
			velocity = velocity.bounce(collision_info.normal)
		rpc_unreliable("set_pos_and_motion_ball", position, velocity)

func start_ball():
	velocity = Vector2()
	if GLOBAL.prev_scored==2:
		velocity.x = -1*(randf()*1+0)
		velocity.y = randf()*0.3+0
	else:
		velocity.x = randf()*1+0
		velocity.y = randf()*0.3+0
	velocity = velocity.normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
