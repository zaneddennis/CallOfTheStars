extends Node2D

var x
var y
var gtType
var ssId
var bgColor
var bgDensity

func _ready():
	pass

func _init(a, b, t, s, bg, d):
	x = a
	y = b
	gtType = t
	ssId = s
	bgColor = bg
	bgDensity = d

func Save(slot):
	var saveStr = str(x) + " " + str(y) + "\n"
	saveStr += str(gtType) + "\n"
	saveStr += str(ssId) + "\n"
	saveStr += str(bgColor) + "\n"
	saveStr += str(bgDensity) + "\n"
	
	var saveFile = File.new()
	saveFile.open("user://SaveFiles/" + slot + "/gTile" + str(x) + "_" + str(y) + ".txt", saveFile.WRITE)
	saveFile.store_line(saveStr)
	saveFile.close()

static func Load(filepath):
	var GalacticTile = load("res://Assets/Scripts/Geography/GalacticTile.gd")
	
	var f = File.new()
	f.open(filepath, f.READ)
	
	var xy = f.get_line()
	var x = xy.split(" ")[0]
	var y = xy.split(" ")[1]
	var gtType = int(f.get_line())
	var ssId = f.get_line()
	var bgColor = f.get_line()
	var bgDensity = f.get_line()
	f.close()
	
	return GalacticTile.new(x, y, gtType, ssId, bgColor, bgDensity)
	