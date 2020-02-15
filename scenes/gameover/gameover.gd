extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GLOBAL.stop_sound("main_track")
	if GLOBAL.score_1>GLOBAL.score_2:
		$winner_text.text="Player 1 won!"
	elif GLOBAL.score_1<GLOBAL.score_2:
		$winner_text.text="Player 2 won!"
	else:
		$winner_text.text="Draw!"
	get_tree().set_network_peer(null)
	GLOBAL.load_scene("boot")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
