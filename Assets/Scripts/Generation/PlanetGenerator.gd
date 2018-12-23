extends Node

var Planet = load("res://Assets/Scripts/Geography/Planet.gd")
var PlanetaryTileset = load("res://Assets/Art/Tilesets/PlanetaryTileset.tres")
var BordersTileset = load("res://Assets/Art/Tilesets/PlanetaryBorderTileset.tres")

var nameGen

var xLen = 24
var yLen = 16

var undergrounds = ["Greystone", "Limestone", "Clay", "Dirt"]
var surfaces = ["Ice", "Snow", "Greystone", "Limestone", "Sandstone", "Dirt", "Grass", "Water", "Grass", "Water", "Sand"]
var heights = ["Flat", "Flat", "Hills", "Mountains"]
var atmospheres = ["None", "Nonbreathable", "Breathable"]

func _ready():
	nameGen = get_node("/root/Base/Utilities/MarkovNamers/LocationNamers/EnglishLocationNamer")

func GeneratePlanet(pId, sId, ring, slot):
	
	var p = Planet.new()
	p.init(pId, "planet", nameGen.Generate(), "Unsettled", sId, ring)
	p.degreePosition = randi()%360
	
	var u = randi()%len(undergrounds)
	p.underground = undergrounds[u]
	var b = randi()%len(surfaces)
	p.baseSurface = surfaces[b]
	
	var s = -1
	if b > 0: 
		s = randi()%b
	else:
		s = 0
	p.secondarySurface = surfaces[s]
	
	var t = -1
	if s > 0:
		t = randi()%s
	else:
		t = 0
	p.tertiarySurface = surfaces[t]
	
	p.atmosphere = atmospheres[randi()%len(atmospheres)]
	for s in ["Water", "Grass"]:
		if s in [p.baseSurface, p.secondarySurface, p.tertiarySurface]:
			p.atmosphere = "Breathable"
	
	p.heightmap = GenerateHeightmap(6, 12, 12, 8, 4, 4)
	p.surfacemap = GenerateSurfaceMap(p.heightmap, surfaces.find(p.baseSurface), surfaces.find(p.secondarySurface), surfaces.find(p.tertiarySurface))
	p.amap = GenerateAMap(p.heightmap, p.surfacemap)
	p.bordermapN = GenerateBorderMapN(p.surfacemap)
	p.bordermapS = GenerateBorderMapS(p.surfacemap)
	p.bordermapE = GenerateBorderMapE(p.surfacemap)
	p.bordermapW = GenerateBorderMapW(p.surfacemap)
	
	p.Save(slot)

func GenerateHeightmap(numBoxes, maxX, maxY, numBoxes2=0, maxX2=0, maxY2=0):
	var map = []
	for x in range(xLen):
    	map.append([])
    	for y in range(yLen):
        	map[x].append(0)
	
	for i in range(numBoxes):
		DrawBox(map, maxX, maxY)
	for i in range(numBoxes2):
		DrawBox(map, maxX2, maxY2)
	
	return map

# pri, sec, and ter are ints
func GenerateSurfaceMap(heightmap, pri, sec, ter):
	var map = []
	for x in range(xLen):
    	map.append([])
    	for y in range(yLen):
        	map[x].append(0)
	
	for x in range(xLen):
		for y in range(yLen):
			if heightmap[x][y] == 0:
				map[x][y] = pri
			elif heightmap[x][y] == 1:
				if randi()%7 == 0:
					map[x][y] = pri
				else:
					map[x][y] = sec
			elif heightmap[x][y] == 2:
				map[x][y] = sec
			elif heightmap[x][y] == 3:
				if randi()%2 == 0:
					map[x][y] = sec
				else:
					map[x][y] = ter
			else:
				map[x][y] = ter
	
	return map

func GenerateAMap(hmap, smap):
	var amap = []
	for x in range(xLen):
		amap.append([])
		for y in range(yLen):
			amap[x].append(0)
	
	for x in range(xLen):
		for y in range(yLen):
			var surface = surfaces[smap[x][y]].to_lower()
			var tilename = ""
			if surface == "water":
				tilename = surface + "_ocean_0"
			else:
				if hmap[x][y] <= 1:
					tilename = surface + "_flat_0"
				elif hmap[x][y] == 2:
					tilename = surface + "_hills_0"
				else:
					tilename = surface + "_mountain_0"
			var tId = PlanetaryTileset.find_tile_by_name(tilename)
			amap[x][y] = tId
	
	return amap

func GenerateBorderMapN(smap):
	var borderMap = []
	for x in range(xLen):
		borderMap.append([])
		for y in range(yLen):
			borderMap[x].append(-1)
	
	for x in range(xLen):
		for y in range(1, yLen):
			var surface = surfaces[smap[x][y-1]].to_lower()
			var tilename = surface + "_0"
			var tId = BordersTileset.find_tile_by_name(tilename)
			borderMap[x][y] = tId
	
	return borderMap

func GenerateBorderMapS(smap):
	var borderMap = []
	for x in range(xLen):
		borderMap.append([])
		for y in range(yLen):
			borderMap[x].append(-1)
	
	for x in range(xLen):
		for y in range(yLen-1):
			var surface = surfaces[smap[x][y+1]].to_lower()
			var tilename = surface + "_0"
			var tId = BordersTileset.find_tile_by_name(tilename)
			borderMap[x][y] = tId
	
	return borderMap

func GenerateBorderMapE(smap):
	var borderMap = []
	for x in range(xLen):
		borderMap.append([])
		for y in range(yLen):
			borderMap[x].append(-1)
	
	for x in range(xLen-1):
		for y in range(yLen):
			var surface = surfaces[smap[x+1][y]].to_lower()
			var tilename = surface + "_0"
			var tId = BordersTileset.find_tile_by_name(tilename)
			borderMap[x][y] = tId
	
	return borderMap

func GenerateBorderMapW(smap):
	var borderMap = []
	for x in range(xLen):
		borderMap.append([])
		for y in range(yLen):
			borderMap[x].append(-1)
	
	for x in range(1, xLen):
		for y in range(yLen):
			var surface = surfaces[smap[x-1][y]].to_lower()
			var tilename = surface + "_0"
			var tId = BordersTileset.find_tile_by_name(tilename)
			borderMap[x][y] = tId
	
	return borderMap

func DrawBox(map, maxX, maxY):
	
	var x1 = (randi() % xLen)
	var y1 = (randi() % yLen)
	var x2 = (randi() % xLen)
	var y2 = (randi() % yLen)
	
	while abs(x1 - x2) > maxX or abs(y1 - y2) > maxY or x1==x2 or y1==y2:
		x1 = (randi() % (xLen-2)) + 1
		y1 = (randi() % (yLen-2)) + 1
		x2 = (randi() % (xLen-2)) + 1
		y2 = (randi() % (yLen-2)) + 1
	
	for x in range(min(x1, x2), max(x1, x2)):
		for y in range(min(y1, y2), max(y1, y2)):
			map[x][y] += 1
	
	return map
