extends Node2D
 # some random number, pick your port properly

#### Network callbacks from SceneTree ####

# callback from SceneTree
func _player_connected(_id):
	GLOBAL.load_scene("connecting")

func _player_disconnected(_id):

	if get_tree().is_network_server():
		_end_game("Client disconnected")
	else:
		_end_game("Server disconnected")

# callback from SceneTree, only for clients (not server)
func _connected_ok():
	# will not use this one
	pass

func _set_status(x,y):
	pass

# callback from SceneTree, only for clients (not server)
func _connected_fail():
	get_tree().set_network_peer(null) #remove peer
	disable_buttons(false)
	get_node("Panel/Connecting").visible=true

func _server_disconnected():
	_end_game("Server disconnected")

##### Game creation functions ######

func _end_game(with_error=""):
	if has_node("/root/pong"):
		#erase pong scene
		get_node("/root/pong").free() # erase immediately, otherwise network might show errors (this is why we connected deferred above)
		show()

	get_tree().set_network_peer(null) #remove peer

	get_node("Panel/Join").set_disabled(false)
	get_node("Panel/Host").set_disabled(false)

	_set_status(with_error, false)

#func _set_status(text, isok):
#	#simple way to show status
#	if isok:
#		get_node("panel/status_ok").set_text(text)
#		get_node("panel/status_fail").set_text("")
#	else:
#		get_node("panel/status_ok").set_text("")
#		get_node("panel/status_fail").set_text(text)







func _on_Host_pressed():
	var upnp:int=GLOBAL.upnp.discover()
	GLOBAL.upnp.add_port_mapping(GLOBAL.DEFAULT_PORT,GLOBAL.DEFAULT_PORT,"Pong MP TCP","TCP")
	GLOBAL.upnp.add_port_mapping(GLOBAL.DEFAULT_PORT,GLOBAL.DEFAULT_PORT,"Pong MP UDP","UDP")

	var host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	var err = host.create_server(GLOBAL.DEFAULT_PORT, 1) # max: 1 peer, since it's a 2 players game
	if err != OK:
		#is another server running?
		_set_status("Can't host, address in use.",false)
		return

	get_tree().set_network_peer(host)
	get_node("Panel/WaitingPlayers").visible=true
	if(upnp==0):
		get_node("Panel/WaitingPlayers").text="Waiting for Players to connect...\nuPNP succesful"+str(GLOBAL.DEFAULT_PORT)
	else:
		get_node("Panel/WaitingPlayers").text="Waiting for Players to connect...\nMake sure Port "+str(GLOBAL.DEFAULT_PORT)+" TCP/UDP is open"
	
	disable_buttons()

func _on_Join_pressed():
	var ip = get_node("Panel/IpAdress").text
	if not ip.is_valid_ip_address():
		_set_status("IP address is invalid", false)
		return

	var host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	host.create_client(ip, GLOBAL.DEFAULT_PORT)
	get_tree().set_network_peer(host)

	_set_status("Connecting..", true)
	get_node("Panel/Connecting").visible=true
	disable_buttons()

### INITIALIZER ####

func _ready():
	# connect all the callbacks related to networking
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	GLOBAL.reset_score()
	$Panel/gamemode.add_item("Normal",0)
	$Panel/gamemode.add_item("EXTREM",1)
	$Panel/gamemode.selected=GLOBAL.gamemode;
	if GLOBAL.music:
		$music.play()

func _on_Local_pressed():
	disable_buttons()
	GLOBAL.load_gamemode();

func disable_buttons(disabled=true):
	for node in get_tree().get_nodes_in_group("ClickingButton"):
		node.set_disabled(disabled)


func _on_SoundToggle_toggled(button_pressed):
	if(!button_pressed):
		GLOBAL.music=false;
		$music.stop();
	else:
		GLOBAL.music=true;
		$music.play();


func _on_SFXToggle_toggled(button_pressed):
	if(!button_pressed):
		GLOBAL.sfx=false;
	else:
		GLOBAL.sfx=true;
	


func _on_gamemode_item_selected(id):
	GLOBAL.gamemode=id
