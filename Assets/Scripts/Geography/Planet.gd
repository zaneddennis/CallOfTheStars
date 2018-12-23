extends Node2D

var Miscellaneous = preload("res://Assets/Scripts/Utility/Miscellaneous.gd")

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
var bordermapN
var bordermapS
var bordermapE
var bordermapW

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
	
	heightmap = p.heightmap
	surfacemap = p.surfacemap
	amap = p.amap
	bordermapN = p.bordermapN
	bordermapS = p.bordermapS
	bordermapE = p.bordermapE
	bordermapW = p.bordermapW

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
	
	saveStr += Miscellaneous.MapToStr(heightmap)
	saveStr += Miscellaneous.MapToStr(surfacemap)
	saveStr += Miscellaneous.MapToStr(amap)
	saveStr += Miscellaneous.MapToStr(bordermapN)
	saveStr += Miscellaneous.MapToStr(bordermapS)
	saveStr += Miscellaneous.MapToStr(bordermapE)
	saveStr += Miscellaneous.MapToStr(bordermapW)
	
	var saveFile = File.new()
	saveFile.open("user://SaveFiles/" + slot + "/planet" + str(planetId) + ".txt", saveFile.WRITE)
	saveFile.store_line(saveStr)
	saveFile.close()

static func Load(filepath):
	var Planet = load("res://Assets/Scripts/Geography/Planet.gd")
	
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
	
	p.heightmap = []
	p.surfacemap = []
	p.amap = []
	p.bordermapN = []
	p.bordermapS = []
	p.bordermapE = []
	p.bordermapW = []
	for x in range(24):
		p.heightmap.append([])
		p.surfacemap.append([])
		p.amap.append([])
		p.bordermapN.append([])
		p.bordermapS.append([])
		p.bordermapE.append([])
		p.bordermapW.append([])
		for y in range(16):
			p.heightmap[x].append(-1)
			p.surfacemap[x].append(-1)
			p.amap[x].append(-1)
			p.bordermapN[x].append(-1)
			p.bordermapS[x].append(-1)
			p.bordermapE[x].append(-1)
			p.bordermapW[x].append(-1)
	
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
	
	f.close()
	
	p.init(i, t, n, o, s, r)
	p.degreePosition = d
	p.underground = u
	p.baseSurface = b
	p.secondarySurface = sec
	p.tertiarySurface = ter
	p.atmosphere = atmo
	
	return p
