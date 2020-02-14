extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var score={}

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().get_network_peer()==null:
		#if local, give all players to local
		get_node("player1").set_network_master(get_tree().get_network_unique_id())
		get_node("player2").set_network_master(get_tree().get_network_unique_id())
	elif get_tree().is_network_server():
		#give client controll over player2
		get_node("player2").set_network_master(get_tree().get_network_connected_peers()[0])
	else:
		#if client, take controll of player2
		get_node("player2").set_network_master(get_tree().get_network_unique_id())
	var curSpeed:float=get_node("ball").speed;
	$speedInfo.text="Speed: "+str(curSpeed)
#	if GLOBAL.online:
#		print("My Unique ID: ", get_tree().get_network_unique_id())
#		print(get_tree().get_network_peer())
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
