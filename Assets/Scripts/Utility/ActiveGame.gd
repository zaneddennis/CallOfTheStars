extends Node2D

# classes
#var GalacticTile = load("res://Assets/Scripts/Geography/GalacticTile.gd")
#var SolarSystem = load("res://Assets/Scripts/Geography/SolarSystem.gd")
#var PlanetScript = load("res://Assets/Scripts/Geography/Planet.gd")

var BackgroundStar = load("res://Assets/Scenes/Geography/BGStar.tscn")
var Sun = load("res://Assets/Scenes/Geography/Sun.tscn")
var PlanetScene = load("res://Assets/Scenes/Geography/Planet.tscn")

# nodes
var background_CR
var galaxy
var miscellaneous

# temporary hardcoded things
var JUMP_LIMIT = 5

# saved things below here
var version
var slot
var phase

var galacticPos

func _ready():
	background_CR = $Background_ColorRect
	galaxy = $Galaxy
	miscellaneous = get_parent().get_node("Utilities/Miscellaneous")
	
	randomize()

func _process(delta):
	pass

func Initialize(v, s):
	version = v
	slot = s
	phase = "space"
	galacticPos = Vector2(0, 0)

func BeginPlaying():
	
	var hud = $FlightHUD_CanvasLayer
	for n in hud.get_children():
		n.visible = true
	
	EnterGTile(galacticPos.x, galacticPos.y)
	
	get_node("Ships/Test_Ship").Build()
	
	$Characters/Player/MainCamera.current = true
	
	get_tree().paused = false

func EnterGTile(x, y):
	# remove previous solar system
	for n in background_CR.get_node("Stars").get_children() + background_CR.get_node("Planets").get_children():
		n.queue_free()
	
	galacticPos = Vector2(x, y)
	
	# instance everything in new solar system
	var gt = galaxy.galTiles[x][y]
	for i in range(gt.bgDensity):
		var bgs = BackgroundStar.instance()
		bgs.position = miscellaneous.RandomVector2(background_CR.get_rect().size)
		background_CR.get_node("Stars").add_child(bgs)
		#bgs.position = Vector2(256, 256)
	
	var planets = []
	if gt.gtType == 1:
		var ss = galaxy.sSystems[int(gt.ssId)]
		
		# instance sun
		var sun = Sun.instance()
		sun.position = background_CR.get_rect().size / 2
		sun.SetColor(ss.sunColor)
		background_CR.get_node("Stars").add_child(sun)
		
		# instance planets
		for r in ss.rings:
			if r[0] == "P":
				var pId = r.substr(1, len(r)-1)
				var p = galaxy.planets[int(pId)]
				var pInstance = PlanetScene.instance()
				pInstance.initFrom(p)
				background_CR.get_node("Planets").add_child(pInstance)
				pInstance.Activate(background_CR.get_rect().size / 2)
				planets.append(pInstance)
		
		
	else:
		pass
	
	# put player at entry point
	
	$FlightHUD_CanvasLayer/Terminal_ColorRect.ActivateSectorMap(gt, planets)

func EnterPTile(p, x, y):
	pass

func Save(slot):
	var saveStr = version + "\n"
	saveStr += slot + "\n"
	saveStr += phase + "\n"
	#saveStr += str(playerPos.x) + " " + str(playerPos.y) + "\n"
	#saveStr += str(playerRot) + "\n"
	saveStr += str(galacticPos.x) + " " + str(galacticPos.y) + "\n"
	
	var saveFile = File.new()
	saveFile.open("user://SaveFiles/" + slot + "/game.txt", saveFile.WRITE)
	saveFile.store_line(saveStr)
	saveFile.close()
	
func Load(args):
	var slot = args[0]
	var caller = args[1]
	
	if Directory.new().dir_exists("user://SaveFiles/" + slot):
		
		var gameFile = File.new()
		gameFile.open("user://SaveFiles/" + slot + "/game.txt", File.READ)
		
		version = gameFile.get_line()
		self.slot = gameFile.get_line()
		phase = gameFile.get_line()
		
		galacticPos = gameFile.get_line()
		var gx = galacticPos.split(" ")[0]
		var gy = galacticPos.split(" ")[1]
		galacticPos = Vector2(gx, gy)
		
		print("Version = " + version)
		$FlightHUD_CanvasLayer/Label.text += " " + version
		
		galaxy.Load(slot)
		
		$GalaxyMap_CanvasLayer.Initialize()
		
		show()
		BeginPlaying()
		
		caller.call_deferred("LoadComplete", "success")
		
	else:
		caller.call_deferred("LoadFailed", "That save does not exist")