extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	GLOBAL.load_scene("main")
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(123456, 2)
	get_tree().set_network_peer(peer)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
