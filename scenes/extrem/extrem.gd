extends "res://scenes/main/main.gd"

var dz_x_min:int
var dz_y_min:int
var dz_x_max:int
var dz_y_max:int
var _master:bool=false


onready var block = preload("res://objects/block.tscn")
var block_positions=[]

func _ready():
	if get_tree().get_network_peer()==null||get_tree().is_network_server():
		_master=true
	set_up_dangerzones()
	$dangerzone_timer.start()

func set_up_dangerzones():
	dz_x_min=round($dangerzone1.position.x)
	dz_y_min=round($dangerzone1.position.y)
	dz_x_max=dz_x_min+round($dangerzone1/shape.get_shape().extents.x*2)
	dz_y_max=dz_y_min+round($dangerzone1/shape.get_shape().extents.y*2)

#	p2_dz_x=round($dangerzone2.position.x)
#	p2_dz_y=round($dangerzone2.position.y)
#	p2_dz_x_width=round($dangerzone2/shape.get_shape().extents.x)
#	p2_dz_y_width=round($dangerzone2/shape.get_shape().extents.y)

func _process(delta):
	if $dangerzone_timer.time_left<5:
		$info.text=str(round($dangerzone_timer.time_left))


func nextDZPosition()->Vector2:
	var random = RandomNumberGenerator.new()
	var dz_player=randi()%2+1
	var vector:Vector2
	if dz_player==1||true:
		var dz_x_middle=dz_x_min+((dz_x_max-dz_x_min)/2)
		random.randomize()
		var x_rnd1=random.randi_range(dz_x_min, dz_x_max)
		random.randomize()
		var x_rnd2=random.randi_range(dz_x_min, dz_x_max)
		random.randomize()
		var y_rnd1=random.randi_range(dz_y_min, dz_y_max)
		var x_rnd1_d=x_rnd1-dz_x_middle
		var x_rnd2_d=x_rnd2-dz_x_middle
		var x_pivot
		if x_rnd1_d>x_rnd2_d:
			x_pivot=x_rnd2
		else:
			x_pivot=x_rnd1
		var y_pivot=y_rnd1
		
		vector = Vector2(x_pivot,y_pivot)
	print(vector)
	
	return vector
	
func _on_dangerzone_timer_timeout():
	$dangerzone_timer.start()
	$info.text=""
	if _master:
		var newBlock=block.instance()
		var newPosition=nextDZPosition()
		newBlock.position=newPosition
		block_positions.append(newPosition)
		get_tree().get_root().get_node("extrem").add_child(newBlock)
		rpc("_spawn_block",newPosition)
puppet func _spawn_block(newPosition:Vector2):
	var newBlock=block.instance()
	newBlock.position=newPosition
	block_positions.append(newPosition)
	get_tree().get_root().get_node("extrem").add_child(newBlock)

