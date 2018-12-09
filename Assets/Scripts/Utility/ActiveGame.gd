extends Node2D

var GalacticTile = load("res://Assets/Scripts/Geography/GalacticTile.gd")
var SolarSystem = load("res://Assets/Scripts/Geography/SolarSystem.gd")
var PlanetScript = load("res://Assets/Scripts/Geography/Planet.gd")

var BackgroundStar = load("res://Assets/Scenes/Geography/BGStar.tscn")
var Sun = load("res://Assets/Scenes/Geography/Sun.tscn")
var PlanetScene = load("res://Assets/Scenes/Geography/Planet.tscn")

var background_CR
#var playerPlaceholder
var galaxy
var miscellaneous

# saved things below here
var version
var slot
var phase

# player placeholder
#var playerPos
#var playerRot
var jumpLimit = 3

var galacticPos

func _ready():
	background_CR = $Background_ColorRect
	#playerPlaceholder = $PlayerPlaceholder
	galaxy = $Galaxy
	miscellaneous = get_parent().get_node("Utilities/Miscellaneous")
	
	randomize()
	for s in get_node("Background_ColorRect").get_children():
		s.position.x = rand_range(0.0, background_CR.rect_size.x)
		s.position.y = rand_range(0.0, background_CR.rect_size.y)

func _process(delta):
	pass

func Initialize(v, s):
	version = v
	slot = s
	phase = "space"
	#playerPos = Vector2(256.0, 256.0)
	#playerRot = 135
	galacticPos = Vector2(0, 0)

func BeginPlaying():
	#playerPlaceholder.position = playerPos
	#playerPlaceholder.rotation_degrees = playerRot
	
	var hud = $FlightHUD_CanvasLayer
	for n in hud.get_children():
		n.visible = true
	
	EnterGTile(galacticPos.x, galacticPos.y)
	
	get_node("Ships/Test_Ship").build()
	
	$Characters/Player/MainCamera.current = true
	
	get_tree().paused = false

func EnterGTile(x, y):
	for n in background_CR.get_children():
		n.queue_free()
	
	galacticPos = Vector2(x, y)
	
	var gt = GalacticTile.Load("user://SaveFiles/" + slot + "/gTile" + str(x) + "_" + str(y) + ".txt")
	
	for i in range(gt.bgDensity):
		var bgs = BackgroundStar.instance()
		bgs.position = miscellaneous.RandomVector2(background_CR.get_rect().size)
		background_CR.add_child(bgs)
	
	var planets = []
	if gt.gtType == 1:
		#print("Loading solar system " + str(gt.ssId))
		var ss = SolarSystem.Load("user://SaveFiles/" + slot + "/ssystem" + str(gt.ssId) + ".txt")
		#print("Sun color: " + ss.sunColor)
		
		# instance sun
		var sun = Sun.instance()
		sun.position = background_CR.get_rect().size / 2
		#sun.position = Vector2(4096, 4096)  # placeholder
		sun.SetColor(ss.sunColor)
		background_CR.add_child(sun)
		
		# instance planets
		#var planets = []
		for r in ss.rings:
			if r[0] == "P":
				var pId = r.substr(1, len(r)-1)
				#print(pId)
				var p = PlanetScript.Load("user://SaveFiles/" + slot + "/planet" + str(pId) + ".txt")
				var pInstance = PlanetScene.instance()
				pInstance.init(p.planetId, p.planetType, p.planetName, p.systemId, p.ring)
				pInstance.degreePosition = p.degreePosition
				pInstance.underground = p.underground
				pInstance.baseSurface = p.baseSurface
				background_CR.add_child(pInstance)
				pInstance.Activate(background_CR.get_rect().size / 2)
				planets.append(pInstance)
		
		
	else:
		pass
	
	# put player at entry point
	
	$FlightHUD_CanvasLayer/Terminal_ColorRect.Activate(gt, planets)

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
	
func Load(slot):
	if Directory.new().dir_exists("user://SaveFiles/" + slot):
		
		var gameFile = File.new()
		gameFile.open("user://SaveFiles/" + slot + "/game.txt", File.READ)
		
		version = gameFile.get_line()
		self.slot = gameFile.get_line()
		phase = gameFile.get_line()
		
		#playerPos = gameFile.get_line()
		#var px = playerPos.split(" ")[0]
		#var py = playerPos.split(" ")[1]
		#playerPos = Vector2(px, py)
		#playerRot = float(gameFile.get_line())
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
		
		return "success"
		
	else:
		return "That save does not exist"