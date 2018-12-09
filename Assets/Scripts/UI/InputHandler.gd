extends Node2D

var ag

var player

var actionBarDict = {"1" : "",
					 "2" : "",
					 "3" : "",
					 "4" : "",
					 "5" : "",
					 "6" : "",
					 "7" : "GalaxyMap",
					 "8" : "",
					 "9" : "",
					 "0" : "",
					 "-" : "",
					 "=" : ""}

func _ready():
	ag = get_parent()
	player = ag.get_node("Characters/Player")

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		PauseGame()
	
	match ag.phase:
		"space":
			HandleSpaceInput()
		_:
			pass

# TO CHANGE: should directly adjust attributes of Player's current ship; UI should read ship instead of this
func HandleSpaceInputOld():
	var throttleBar = ag.get_node("FlightHUD_CanvasLayer/Throttle_TextureProgress")
	var pPlaceholder = ag.get_node("PlayerPlaceholder")
	
	if Input.is_action_pressed("throttle_up"):
		throttleBar.value += 1
	if Input.is_action_pressed("throttle_down"):
		throttleBar.value -= 1
	if Input.is_action_pressed("turn_left"):
		pPlaceholder.rotation_degrees -= 1
	if Input.is_action_pressed("turn_right"):
		pPlaceholder.rotation_degrees += 1
	
	if Input.is_action_just_pressed("close_window"):
		get_parent().get_node("GalaxyMap_CanvasLayer/GalaxyMap_ColorRect").visible = false
	
	HandleGalaxyMapInput()

func HandleSpaceInput():
	if Input.is_action_pressed("throttle_up"):
		player.currentShip.throttle += 1
	if Input.is_action_pressed("throttle_down"):
		player.currentShip.throttle -= 1
	if Input.is_action_pressed("turn_left"):
		player.currentShip.rotation_degrees -= 1
	if Input.is_action_pressed("turn_right"):
		player.currentShip.rotation_degrees += 1
	
	if Input.is_action_just_pressed("close_window"):
		get_parent().get_node("GalaxyMap_CanvasLayer/GalaxyMap_ColorRect").visible = false
	
	HandleGalaxyMapInput()

func HandleGalaxyMapInput():
	if get_parent().get_node("GalaxyMap_CanvasLayer/GalaxyMap_ColorRect").visible == true:
		if Input.is_action_just_pressed("map_select"):
			var mCR = get_parent().get_node("GalaxyMap_CanvasLayer/GalaxyMap_ColorRect/Map_ColorRect")
			
			#var selector = mCR.get_node("Icons/GalTileSelector_Sprite")
			var mPos = get_viewport().get_mouse_position()
			var mapRect = mCR.get_global_rect()
	
			
			if mapRect.has_point(mPos):
				var mRelPos = mPos - mapRect.position
				var x = int(mRelPos.x) / 16
				var y = int(mRelPos.y) / 16
				get_parent().get_node("GalaxyMap_CanvasLayer").SelectTile(x, y)
				
			else:
				pass

func PauseGame():
	get_tree().paused = true
	
	var pm = get_parent().get_node("PauseMenu_CanvasLayer")
	for n in pm.get_children():
		n.visible = true

func ActionBar(n):
	call(actionBarDict[n])

func GalaxyMap():
	get_parent().get_node("GalaxyMap_CanvasLayer").Activate()
	#var gm = get_parent().get_node("GalaxyMap_CanvasLayer")
	#for n in gm.get_children():
	#	n.visible = true
