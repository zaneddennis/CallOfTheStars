extends Node

var Miscellaneous = preload("res://Assets/Scripts/Utility/Miscellaneous.gd")

var planetId
var x
var y

var baseSurface
var altitude

var heightmap
var surfacemap

func _ready():
	pass

func _init(pId, x_, y_):
	planetId = pId
	x = x_
	y = y_

func ToSaveStr():
	var saveStr = str(planetId) + "\n"
	saveStr += str(x) + " " + str(y) + "\n"
	
	saveStr += str(baseSurface) + "\n"
	saveStr += str(altitude) + "\n"
	
	saveStr += str(Miscellaneous.MapToStr(heightmap))
	saveStr += str(Miscellaneous.MapToStr(surfacemap))
	
	return saveStr

static func LoadFrom(file):
	var PlanetaryTile = load("res://Assets/Scripts/Geography/PlanetaryTile.gd")
	
	var pId = int(file.get_line())
	var coords = file.get_line().split(" ")
	var bs = file.get_line()
	var alt = file.get_line()
	
	var pt = PlanetaryTile.new(pId, int(coords[0]), int(coords[1]))
	pt.baseSurface = bs
	pt.altitude = alt
	
	pt.heightmap = []
	pt.surfacemap = []
	for x in range(24):
		pt.heightmap.append([])
		pt.surfacemap.append([])
		for y in range(16):
			pt.heightmap[x].append(0)
			pt.surfacemap[x].append(-1)
	
	for y in range(16):
		var line = file.get_line()
		var row = line.split(" ")
		for x in range(24):
			pt.heightmap[x][y] = int(row[x])
	
	for y in range(16):
		var line = file.get_line()
		var row = line.split(" ")
		for x in range(24):
			pt.surfacemap[x][y] = int(row[x])
	
	return pt