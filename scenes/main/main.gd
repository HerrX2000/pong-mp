extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var score={}

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().is_network_server():
		#if in the server, get control of player 2 to the other peeer, this function is tree recursive by default
		get_node("player1").set_network_master(get_tree().get_network_connected_peers()[0])
	else:
		#if in the client, give control of player 2 to itself, this function is tree recursive by default
		get_node("player2").set_network_master(get_tree().get_network_unique_id())


	print("unique id: ", get_tree().get_network_unique_id())
	
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
