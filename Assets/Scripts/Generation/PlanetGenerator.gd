extends Node

var Planet = load("res://Assets/Scripts/Geography/Planet.gd")

var undergrounds = ["Dirt", "Greystone", "Limestone"]
var bases = ["Ice", "Snow", "Greystone", "Sandstone", "Limestone", "Water", "Dirt", "Sand"]
var surfaces = bases + ["Grass", "Tallgrass", "Forest", "Jungle", "Swamp"]

func _ready():
	pass

func GeneratePlanet(pId, sId, ring, slot):
	
	#var p = Planet.new(pId, "planet", "Planet" + str(pId), sId, ring)
	var p = Planet.new()
	p.init(pId, "planet", "Planet" + str(pId), sId, ring)
	p.degreePosition = randi()%360
	
	p.underground = undergrounds[randi()%len(undergrounds)]
	p.baseSurface = bases[randi()%len(bases)]
	
	p.Save(slot)
