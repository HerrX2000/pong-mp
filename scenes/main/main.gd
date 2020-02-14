extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var score={}

# Called when the node enters the scene tree for the first time.
func _ready():
	pre_configure_game();
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

remote func pre_configure_game():
	var selfPeerID = get_tree().get_network_unique_id()

	# Load my player
	var my_player = preload("res://objects/player.tscn").instance()
	player1.set_name(str(selfPeerID))
	player1.set_network_master(selfPeerID) # Will be explained later
	get_node("/root/world/players").add_child(my_player)

	# Load other players
	for p in player_info:
		var player2 = preload("res://objects/player.tscn").instance()
		player2.set_name(str(p))
		player2.set_network_master(p) # Will be explained later
		get_node("/root/world/players").add_child(player)

	# Tell server (remember, server is always ID=1) that this peer is done pre-configuring.
	rpc_id(1, "done_preconfiguring", selfPeerID)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
