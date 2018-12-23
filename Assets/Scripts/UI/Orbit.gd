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
	currentPlanet = ag.get_node("Background_ColorRect/" + player.currentShip.orbitingPlanet)
	
	$Orbit_ColorRect/PlanetName_Label.text = currentPlanet.planetName
	$Orbit_ColorRect/FactionName_Label.text = currentPlanet.planetOwner
	
	var tm = $Orbit_ColorRect/PlanetMap_ColorRect/PlanetMap_TileMap
	for x in range(24):
		for y in range(16):
			tm.set_cell(x, y, currentPlanet.amap[x][y])
	
	tm = $Orbit_ColorRect/PlanetMap_ColorRect/BorderN_TileMap
	for x in range(24):
		for y in range(16):
			tm.set_cell(x, y, currentPlanet.bordermapN[x][y])
	
	tm = $Orbit_ColorRect/PlanetMap_ColorRect/BorderS_TileMap
	for x in range(24):
		for y in range(16):
			tm.set_cell(x, y, currentPlanet.bordermapS[x][y], false, true)
	
	tm = $Orbit_ColorRect/PlanetMap_ColorRect/BorderE_TileMap
	for x in range(24):
		for y in range(16):
			tm.set_cell(x, y, currentPlanet.bordermapE[x][y], true, false, true)
	
	tm = $Orbit_ColorRect/PlanetMap_ColorRect/BorderW_TileMap
	for x in range(24):
		for y in range(16):
			tm.set_cell(x, y, currentPlanet.bordermapW[x][y], false, false, true)
	
	for n in get_children():
		n.visible = true
	
	SelectTile(0, 0)

func SelectTile(x, y):
	selectedX = x
	selectedY = y
	
	$Orbit_ColorRect/PlanetMap_ColorRect/TileSelector_Sprite.position = Vector2(24*x, 24*y)
	
	var surface = pg.surfaces[currentPlanet.surfacemap[x][y]]
	$Orbit_ColorRect/TileInfo_ColorRect/Terrain_Label.text = "Primary Terrain: " + surface
	if surface != "Water":
		var height = currentPlanet.heightmap[x][y]
		if height > 3:
			height = 3
		$Orbit_ColorRect/TileInfo_ColorRect/Terrain_Label.text += ", " + pg.heights[height]
	
	$Orbit_ColorRect/PlanetInfo_ColorRect/Atmosphere_Label.text = "Atmosphere: " + currentPlanet.atmosphere
