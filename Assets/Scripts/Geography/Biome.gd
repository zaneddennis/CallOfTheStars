class_name Biome

var planet

var baseTemp
var baseMoisture
var tHarshness

var soil

var tFeatures
var wFeatures

var flora
var fauna

var sColor
var gcColor
var lfColor

func _init(p, t, m, h):
	planet = p
	
	baseTemp = t
	baseMoisture = m
	tHarshness = h

func _ready():
	pass

func ToStr():
	return "[Biome: %s/%s/%s]" % [baseTemp, baseMoisture, tHarshness]

func DetailsToStr():
	var result = "[Biome: %s/%s/%s]\n" % [baseTemp, baseMoisture, tHarshness]
	
	result += "\tPlanet: " + planet.planetName + "\n"
	result += "\tSoil: " + soil + "\n"
	result += "\tSoil Color: " + str(sColor) + "\n"
	result += "\tGroundcover Color: " +  str(gcColor) + "\n"
	
	return result
