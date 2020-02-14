extends KinematicBody2D

export (int) var speed = 300
var velocity = Vector2()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	get_input()
	move_and_slide(velocity)

func get_input():
    velocity = Vector2()
    if Input.is_action_pressed('player1_down'):
        velocity.y += 1
    if Input.is_action_pressed('player1_up'):
        velocity.y -= 1
    velocity = velocity.normalized() * speed
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
