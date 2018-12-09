extends Node

var Planet = load("res://Assets/Scripts/Geography/Planet.gd")

var nameGen

var undergrounds = ["Dirt", "Greystone", "Limestone"]
var bases = ["Ice", "Snow", "Greystone", "Sandstone", "Limestone", "Water", "Dirt", "Sand"]
var surfaces = bases + ["Grass", "Tallgrass", "Forest", "Jungle", "Swamp"]

func _ready():
	nameGen = get_node("/root/Base/Utilities/MarkovNamers/LocationNamers/EnglishLocationNamer")

func GeneratePlanet(pId, sId, ring, slot):
	
	var p = Planet.new()
	#p.init(pId, "planet", "Planet" + str(pId), sId, ring)
	p.init(pId, "planet", nameGen.Generate(), "Unsettled", sId, ring)
	p.degreePosition = randi()%360
	
	p.underground = undergrounds[randi()%len(undergrounds)]
	p.baseSurface = bases[randi()%len(bases)]
	
	p.Save(slot)
