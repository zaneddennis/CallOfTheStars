extends CanvasLayer

var Miscellaneous = preload("res://Assets/Scripts/Utility/Miscellaneous.gd")
var PlanetGenerator = preload("res://Assets/Scripts/Generation/PlanetGenerator.gd")

var ag
var player
var pg

var currentPlanet

var selectedX = 0
var selectedY = 0

func _ready():
	ag = get_parent()
	player = ag.get_node("Characters/Player")
	pg = PlanetGenerator.new()

func Activate():
	currentPlanet = ag.get_node("Background_ColorRect/Planets/" + player.currentShip.orbitingPlanet)
	print(currentPlanet.name)
	print(currentPlanet.planetId)
	
	$Orbit_ColorRect/PlanetName_Label.text = currentPlanet.planetName
	$Orbit_ColorRect/FactionName_Label.text = currentPlanet.planetOwner
	
	var tex = ImageTexture.new()
	tex.load("user://SaveFiles/" + ag.slot + "/planet" + str(currentPlanet.planetId) + ".png")
	$Orbit_ColorRect/PlanetMap_TextureRect.texture = tex
	
	for n in get_children():
		n.visible = true
	
	$Orbit_ColorRect/PlanetInfo_ColorRect/Atmosphere_Label.text = "Atmosphere: " + str(currentPlanet.atmosphere)
	$Orbit_ColorRect/PlanetInfo_ColorRect/Bedrock_Label.text = "Bedrock: " + str(currentPlanet.bedrock)
	
	SelectTile(0, 0)


func SelectTile(x, y):
	selectedX = x
	selectedY = y
	
	$Orbit_ColorRect/PlanetMap_TextureRect/TileSelector_Sprite.position = Vector2(24*x, 24*y)
	
	var psts = []
	for x_ in range(x*2, 2+x*2):
		for y_ in range(y*2, 2+y*2):
			psts.append(currentPlanet.biomeMap.Get(x_, y_))  # get actual Biomes
	
	print(psts)


func _on_Land_Button_pressed():
	print("Landing on tile ", selectedX, " ", selectedY)
	ag.EnterPTile(currentPlanet, selectedX, selectedY)
