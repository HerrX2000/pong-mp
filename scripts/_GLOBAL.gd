extends CanvasLayer

var debug_mode:bool = false
var scene_name:String = "boot"
var current_music:String = ""
var file:File = File.new()
var file_path:String
var scene_fade:Node
var game_nmb:int = 0
var score_1:int = 0
var score_2:int = 0
var prev_scored:int = 1

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.




func load_scene(scene:String) -> void:
	GLOBAL.scene_name = scene
	restart_scene()

func scored(player:int) -> void:
	match player:
			1:
				score_1+=1
			2:
				score_2+=2
	$sfx/score.play()
	prev_scored=player
	game_nmb+=1
	restart_scene()

func score():
	return [score_1,score_2]


func restart_scene() -> void:
	yield(get_tree().create_timer(2), "timeout")

	#scene_fade = scene_fade_out(.5)
	#yield(scene_fade, "tween_completed")

	file_path = "res://scenes/"+scene_name+"/"+scene_name+".tscn"
	if file.file_exists(file_path):
		get_tree().change_scene(file_path)

	#scene_fade = scene_fade_in(.5)
	#yield(scene_fade, "tween_completed")
	#$color.hide()
	get_tree().paused = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func scene_fade_out(time:float) -> Node:
	get_tree().paused = true
	return scene_fade(0, 1, time)
	
func scene_fade_in(time:float) -> Node:
	return scene_fade(1, 0, time)
	
func scene_fade(start:int, end:int, time:float) -> Node:
	$color.modulate = Color(0,0,0,start)
	$color.show()

	$tween.stop_all()
	$tween.interpolate_property($color, "modulate", Color(0,0,0,start), Color(0,0,0,end), time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$tween.start()

	return $tween
