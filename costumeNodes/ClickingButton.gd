extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("ClickingButton")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("pressed",self,"_on_pressed")

func _on_mouse_entered():
	if !disabled:
		GLOBAL.play_sfx("click")

func _on_pressed():
	if !disabled:
		GLOBAL.play_sfx("ready")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
