extends CanvasLayer

var Miscellaneous = preload("res://Assets/Scripts/Utility/Miscellaneous.gd")

var ag
var player

func _ready():
	ag = get_parent()
	player = ag.get_node("Characters/Player")

func Activate():
	var planet = ag.get_node("Background_ColorRect/" + player.currentShip.orbitingPlanet)
	
	$Orbit_ColorRect/PlanetName_Label.text = planet.planetName
	$Orbit_ColorRect/FactionName_Label.text = planet.planetOwner
	
	print(planet.name)
	print("Heightmap:")
	print(Miscellaneous.MapToStr(planet.heightmap))
	print("Surface Map:")
	print(Miscellaneous.MapToStr(planet.surfacemap))
	print("A Map:")
	print(Miscellaneous.MapToStr(planet.amap))
	
	var tm = $Orbit_ColorRect/PlanetMap_ColorRect/PlanetMap_TileMap
	for x in range(24):
		for y in range(16):
			tm.set_cell(x, y, planet.amap[x][y])
	
	for n in get_children():
		n.visible = true
