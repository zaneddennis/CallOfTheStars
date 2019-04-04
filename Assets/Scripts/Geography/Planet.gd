extends Node2D

var Miscellaneous = preload("res://Assets/Scripts/Utility/Miscellaneous.gd")

#var PlanetaryTile = preload("res://Assets/Scripts/Geography/PlanetaryTile.gd")

const RING_SIZE = 512

var planetId
var planetType
var planetName
var planetOwner

var systemId
var ring
var degreePosition

var underground
var baseSurface
var secondarySurface
var tertiarySurface
var atmosphere

var heightmap
var surfacemap
var amap
var bmap
var bordermapN
var bordermapS
var bordermapE
var bordermapW

var tiles

var resources = {}  # planet base rate

func _ready():
	pass

func init(i, t, n, o, s, r):
	planetId = i
	planetType = t
	planetName = n
	planetOwner = o
	
	systemId = s
	ring = r

func initFrom(p):
	planetId = p.planetId
	planetType = p.planetType
	planetName = p.planetName
	planetOwner = p.planetOwner
	
	systemId = p.systemId
	ring = p.ring
	degreePosition = p.degreePosition
	
	underground = p.underground
	baseSurface = p.baseSurface
	secondarySurface = p.secondarySurface
	tertiarySurface = p.tertiarySurface
	atmosphere = p.atmosphere
	resources = p.resources
	
	heightmap = p.heightmap
	surfacemap = p.surfacemap
	amap = p.amap
	bmap = p.bmap
	bordermapN = p.bordermapN
	bordermapS = p.bordermapS
	bordermapE = p.bordermapE
	bordermapW = p.bordermapW
	
	tiles = p.tiles

func Activate(center):
	position = polar2cartesian((ring+3)*RING_SIZE, deg2rad(degreePosition - 90)) + center
	$Base_Sprite.texture = load("res://Assets/Art/Planets/Planet" + baseSurface + "Base.png")
	name = planetName

func Save(slot):
	var saveStr = str(planetId) + "\n"
	saveStr += planetType + "\n"
	saveStr += planetName + "\n"
	saveStr += planetOwner + "\n"
	saveStr += str(systemId) + "\n"
	saveStr += str(ring) + "\n"
	saveStr += str(degreePosition) + "\n"
	saveStr += underground + "\n"
	saveStr += baseSurface + "\n"
	saveStr += secondarySurface + "\n"
	saveStr += tertiarySurface + "\n"
	saveStr += atmosphere + "\n"
	
	var line = ""
	for r in resources:
		line +=  r + "|" + str(resources[r])  + " "
	line = line.substr(0, len(line)-1)
	saveStr += line + "\n"
	
	saveStr += Miscellaneous.MapToStr(heightmap)
	saveStr += Miscellaneous.MapToStr(surfacemap)
	saveStr += Miscellaneous.MapToStr(amap)
	saveStr += Miscellaneous.MapToStr(bmap)
	saveStr += Miscellaneous.MapToStr(bordermapN)
	saveStr += Miscellaneous.MapToStr(bordermapS)
	saveStr += Miscellaneous.MapToStr(bordermapE)
	saveStr += Miscellaneous.MapToStr(bordermapW)
	
	# save tiles
	"""for y in range(16):
		for x in range(24):
			saveStr += tiles[x][y].ToSaveStr()"""
	
	var saveFile = File.new()
	saveFile.open("user://SaveFiles/" + slot + "/planet" + str(planetId) + ".txt", saveFile.WRITE)
	saveFile.store_line(saveStr)
	saveFile.close()

static func Load(filepath):
	var Planet = load("res://Assets/Scripts/Geography/Planet.gd")
	var PlanetaryTile = load("res://Assets/Scripts/Geography/PlanetaryTile.gd")
	
	var f = File.new()
	f.open(filepath, f.READ)
	
	var p = Planet.new()
	
	var i = int(f.get_line())
	var t = f.get_line()
	var n = f.get_line()
	var o = f.get_line()
	var s = int(f.get_line())
	var r = int(f.get_line())
	var d = int(f.get_line())
	var u = f.get_line()
	var b = f.get_line()
	var sec = f.get_line()
	var ter = f.get_line()
	var atmo = f.get_line()
	
	var res = f.get_line()
	for kv in res.split(" "):
		var rName = kv.split("|")[0]
		var rValue = kv.split("|")[1]
		p.resources[rName] = float(rValue)
	
	p.heightmap = []
	p.surfacemap = []
	p.amap = []
	p.bmap = []
	p.bordermapN = []
	p.bordermapS = []
	p.bordermapE = []
	p.bordermapW = []
	p.tiles = []
	for x in range(24):
		p.heightmap.append([])
		p.surfacemap.append([])
		p.amap.append([])
		p.bmap.append([])
		p.bordermapN.append([])
		p.bordermapS.append([])
		p.bordermapE.append([])
		p.bordermapW.append([])
		p.tiles.append([])
		for y in range(16):
			p.heightmap[x].append(-1)
			p.surfacemap[x].append(-1)
			p.amap[x].append(-1)
			p.bmap[x].append(-1)
			p.bordermapN[x].append(-1)
			p.bordermapS[x].append(-1)
			p.bordermapE[x].append(-1)
			p.bordermapW[x].append(-1)
			p.tiles[x].append(-1)
	
	for y in range(16):
		var line = f.get_line()
		var row = line.split(" ")
		for x in range(24):
			p.heightmap[x][y] = int(row[x])
	
	for y in range(16):
		var line = f.get_line()
		var row = line.split(" ")
		for x in range(24):
			p.surfacemap[x][y] = int(row[x])
	
	for y in range(16):
		var line = f.get_line()
		var row = line.split(" ")
		for x in range(24):
			p.amap[x][y] = int(row[x])
	
	for y in range(16):
		var line = f.get_line()
		var row = line.split(" ")
		for x in range(24):
			p.bmap[x][y] = int(row[x])
	
	for y in range(16):
		var line = f.get_line()
		var row = line.split(" ")
		for x in range(24):
			p.bordermapN[x][y] = int(row[x])
	
	for y in range(16):
		var line = f.get_line()
		var row = line.split(" ")
		for x in range(24):
			p.bordermapS[x][y] = int(row[x])
	
	for y in range(16):
		var line = f.get_line()
		var row = line.split(" ")
		for x in range(24):
			p.bordermapE[x][y] = int(row[x])
	
	for y in range(16):
		var line = f.get_line()
		var row = line.split(" ")
		for x in range(24):
			p.bordermapW[x][y] = int(row[x])
	
	# load tiles
	pass
	
	f.close()
	
	p.init(i, t, n, o, s, r)
	p.degreePosition = d
	p.underground = u
	p.baseSurface = b
	p.secondarySurface = sec
	p.tertiarySurface = ter
	p.atmosphere = atmo
	
	return p
