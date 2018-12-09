extends Node2D

var Ship = preload("res://Assets/Scripts/Ships/Ship.gd")

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
			if player.currentShip != null:
				HandleSpaceInput()
		_:
			pass

func HandleSpaceInput():
	if player.currentShip.orbitingPlanet == "":
		HandleSpaceMovement()
	
	if Input.is_action_just_pressed("close_window"):
		get_parent().get_node("GalaxyMap_CanvasLayer/GalaxyMap_ColorRect").visible = false
		
		if player.currentShip.orbitingPlanet:
			get_parent().get_node("Orbit_CanvasLayer/Orbit_ColorRect").visible = false
			get_parent().get_node("FlightHUD_CanvasLayer/Terminal_ColorRect/SectorMap_CR/Orbit_TextureProgress").value = 5
			player.currentShip.LeaveOrbit()
	
	if player.currentShip != null:
		var orbitProgress = get_parent().get_node("FlightHUD_CanvasLayer/Terminal_ColorRect/SectorMap_CR/Orbit_TextureProgress")
		if player.currentShip.overPlanet != "" and orbitProgress.value < 100:
			if Input.is_action_pressed("interact"):
				orbitProgress.value += 2
			else:
				orbitProgress.value = 5
		elif orbitProgress.value == 100 and player.currentShip.orbitingPlanet == "":
			player.currentShip.Orbit()
			ag.get_node("Orbit_CanvasLayer").Activate()
	
	HandleGalaxyMapInput()

func HandleSpaceMovement():
	if Input.is_action_pressed("throttle_up"):
		player.currentShip.throttle += 1
	if Input.is_action_pressed("throttle_down"):
		player.currentShip.throttle -= 1
	if Input.is_action_pressed("turn_left"):
		player.currentShip.rotation_degrees -= 1
	if Input.is_action_pressed("turn_right"):
		player.currentShip.rotation_degrees += 1

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
