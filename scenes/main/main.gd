extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var score={}

# Called when the node enters the scene tree for the first time.
func _ready():
	$goal_1.connect("body_entered", self, "on_body_entered", [2])
	$goal_2.connect("body_entered", self, "on_body_entered", [1])
	if GLOBAL.game_nmb!=0:
		$info.text=str("")

func on_body_entered(body,player) -> void:
	if body.name=="ball":
		print("Goal by: ",player)
		$info.text=str("Goal by Player ",player)
		GLOBAL.scored(player)
	score=GLOBAL.score()
	$score_1.text=str(score[0])
	$score_2.text=str(score[1])
# Called every fram
func _process(delta):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
