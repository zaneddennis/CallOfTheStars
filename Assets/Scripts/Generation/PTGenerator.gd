extends Node

var PlanetaryTile = load("res://Assets/Scripts/Geography/PlanetaryTile.gd")

var planetSurfaces = ["Ice", "Snow", "Greystone", "Limestone", "Sandstone", "Dirt", "Grass", "Water", "Grass", "Water", "Sand"]

func _ready():
	pass

func GeneratePT(x, y, p):
	#print("Generating Planetary Tile " + str(ptId))
	
	var pt = PlanetaryTile.new(p.planetId, x, y)
	
	pt.baseSurface = p.surfacemap[x][y]
	pt.altitude = p.heightmap[x][y]
	
	# generate heightmap
	pt.heightmap = []
	for x in range(64):
		pt.heightmap.append([])
		for y in range(64):
			pt.heightmap[x].append(0)
	
	# generate surfacemap
	pt.surfacemap = []
	for x in range(64):
		pt.surfacemap.append([])
		for y in range(64):
			pt.surfacemap[x].append(pt.baseSurface)
	
	return pt
	#pt.Save(slot)