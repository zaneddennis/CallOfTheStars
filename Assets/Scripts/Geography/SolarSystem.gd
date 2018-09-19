extends Node2D

const NUM_RINGS = 12

var ssId
var ssName
var xPos
var yPos
var sunColor
var rings = []


func _ready():
	pass

func _init():
	for i in range(NUM_RINGS):
		rings.append([])

func Save(slot):
	var saveStr = str(ssId) + "\n"
	saveStr += ssName + "\n"
	saveStr += str(xPos) + " " + str(yPos) + "\n"
	saveStr += sunColor + "\n"
	for r in rings:
		saveStr += r[0] + "\n"
	
	var saveFile = File.new()
	#saveFile.open("res://SaveFiles/Slot" + str(slot) + "/ssystem" + str(ssId) + ".txt", saveFile.WRITE)
	saveFile.open("user://SaveFiles/" + slot + "/ssystem" + str(ssId) + ".txt", saveFile.WRITE)
	saveFile.store_line(saveStr)
	saveFile.close()

static func Load(filepath):
	var SolarSystem = load("res://Assets/Scripts/Geography/SolarSystem.gd")
	var ss = SolarSystem.new()
	
	var f = File.new()
	f.open(filepath, f.READ)
	
	ss.ssId = int(f.get_line())
	ss.ssName = f.get_line()
	var xy = f.get_line()
	ss.xPos = xy.split(" ")[0]
	ss.yPos = xy.split(" ")[1]
	ss.sunColor = f.get_line()
	
	for r in NUM_RINGS:
		ss.rings[r] = f.get_line()
	f.close()
	
	return ss