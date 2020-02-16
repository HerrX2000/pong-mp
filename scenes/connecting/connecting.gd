extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().is_network_server():
		GLOBAL.start_sync()

func _process(delta):
	if GLOBAL.synced==true:
		GLOBAL.load_gamemode()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
