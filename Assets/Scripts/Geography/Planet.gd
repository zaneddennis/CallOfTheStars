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
var baseSurface

var atmosphere
var temperature
var moisture
var bedrock

var heightmap
var temperatureMap
var moistureMap
var watermap

var oceanCol

var biomes
var biomeMap


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
	baseSurface = p.baseSurface
	
	atmosphere = p.atmosphere
	temperature = p.temperature
	moisture = p.moisture
	bedrock = p.bedrock
	
	heightmap = p.heightmap
	watermap = p.watermap
	temperatureMap = p.temperatureMap
	moistureMap = p.moistureMap
	biomeMap = p.biomeMap
	
	oceanCol = p.oceanCol
	
	biomes = p.biomes

func Activate(center):
	position = polar2cartesian((ring+3)*RING_SIZE, deg2rad(degreePosition - 90)) + center
	$Base_Sprite.texture = load("res://Assets/Art/Planets/Planet" + baseSurface + "Base.png")
	name = planetName

func Render(slot):
	var img = Image.new()
	img.create(heightmap.X_SIZE*12, heightmap.Y_SIZE*12, false, Image.FORMAT_RGBA8)
	img.lock()
	
	#img.fill(ColorN("blue"))
	for x in range(heightmap.X_SIZE):
		for y in range(heightmap.Y_SIZE):
			RenderTileCenter(img, x, y)
			
			if watermap != null and watermap.Get(x, y) in [7, 8, 9, 6, 3, 2, 1, 4]:
				RenderRiver(img, x, y)
	
	img.unlock()
	img.save_png("user://SaveFiles/" + slot + "/planet" + str(planetId) + ".png")

func RenderTileCenter(img, x, y):
	var startX = x*12 + 2
	var startY = y*12 + 2
	
	for x_ in range(startX, startX+8):
		for y_ in range(startY, startY+8):
			#img.set_pixel(x_, y_, ColorN("blue"))
			
			if atmosphere and (str(biomeMap.Get(x, y)) == "."):  # is water
				img.set_pixel(x_, y_, oceanCol)
			else:
				img.set_pixel(x_, y_, biomes[biomeMap.Get(x, y)].sColor)
				# (insert actual algorithm here)

func RenderRiver(img, x, y):
	var startX = x*12 + 5
	var startY = y*12 + 5
	
	for x_ in range(startX, startX+2):
		for y_ in range(startY, startY+2):
			img.set_pixel(x_, y_, oceanCol)

func Save(slot):
	var saveStr = str(planetId) + "\n"
	saveStr += planetType + "\n"
	saveStr += planetName + "\n"
	saveStr += planetOwner + "\n"
	
	saveStr += str(systemId) + "\n"
	saveStr += str(ring) + "\n"
	saveStr += str(degreePosition) + "\n"
	saveStr += str(baseSurface) + "\n"
	
	saveStr += str(int(atmosphere)) + "\n"
	saveStr += str(temperature) + "\n"
	saveStr += str(moisture) + "\n"
	saveStr += bedrock + "\n"
	
	# maps
	saveStr += heightmap.ToStr()
	saveStr += temperatureMap.ToStr()
	saveStr += moistureMap.ToStr()
	
	if atmosphere:
		saveStr += watermap.ToStr()
	
	# biomes
	saveStr += biomeMap.ToStr()
	
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
	p.init(i, t, n, o, s, r)
	
	p.degreePosition = int(f.get_line())
	p.baseSurface = f.get_line()
	
	p.atmosphere = bool(int(f.get_line()))
	p.temperature = int(f.get_line())
	p.moisture = int(f.get_line())
	p.bedrock = f.get_line()
	
	# maps
	p.heightmap = Map.new(48, 32)
	p.heightmap.Load(f)
	p.temperatureMap = Map.new(48, 32)
	p.temperatureMap.Load(f)
	p.moistureMap = Map.new(48, 32)
	p.moistureMap.Load(f)
	
	if p.atmosphere:
		p.watermap = Map.new(48, 32)
		p.watermap.Load(f)
	
	
	# biomes
	p.biomeMap = Map.new(48, 32)
	p.biomeMap.Load(f)
	
	f.close()
	
	return p
