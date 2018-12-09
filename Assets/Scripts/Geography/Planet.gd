extends Node2D

const RING_SIZE = 512

var planetId
var planetType
var planetName

var systemId
var ring
var degreePosition

var underground
var baseSurface

func _ready():
	pass

func init(i, t, n, s, r):
	planetId = i
	planetType = t
	planetName = n
	
	systemId = s
	ring = r

func Activate(center):
	#position = Vector2(randi()%4096, randi()%4096)
	position = polar2cartesian((ring+3)*RING_SIZE, deg2rad(degreePosition - 90)) + center
	$Base_Sprite.texture = load("res://Assets/Art/Planets/Planet" + baseSurface + "Base.png")
	name = planetName

func Save(slot):
	var saveStr = str(planetId) + "\n"
	saveStr += planetType + "\n"
	saveStr += planetName + "\n"
	saveStr += str(systemId) + "\n"
	saveStr += str(ring) + "\n"
	saveStr += str(degreePosition) + "\n"
	saveStr += underground + "\n"
	saveStr += baseSurface + "\n"
	
	
	var saveFile = File.new()
	saveFile.open("user://SaveFiles/" + slot + "/planet" + str(planetId) + ".txt", saveFile.WRITE)
	saveFile.store_line(saveStr)
	saveFile.close()

static func Load(filepath):
	var Planet = load("res://Assets/Scripts/Geography/Planet.gd")
	
	var f = File.new()
	f.open(filepath, f.READ)
	
	var i = int(f.get_line())
	var t = f.get_line()
	var n = f.get_line()
	var s = int(f.get_line())
	var r = int(f.get_line())
	var d = int(f.get_line())
	var u = f.get_line()
	var b = f.get_line()
	
	f.close()
	
	var p = Planet.new()
	p.init(i, t, n, s, r)
	p.degreePosition = d
	p.underground = u
	p.baseSurface = b
	
	return p
