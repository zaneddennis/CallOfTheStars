extends Node

signal completedSS(planets)

var SolarSystem = load("res://Assets/Scripts/Geography/SolarSystem.gd")
var planetGenerator

var sunColors = ["Yellow", "White", "Orange"]

func _ready():
	pass
	
	planetGenerator = get_parent().get_node("PlanetGenerator")

func GenerateSystemSeq(x, y, sId, nextPid, slot):
	var ss = SolarSystem.new()
	var planets = []
	
	ss.ssId = sId
	ss.ssName = "System" + str(sId) #ssystems get a real name when claimed by a Faction
	ss.xPos = x
	ss.yPos = y
	ss.sunColor = sunColors[randi() % len(sunColors)]
	for i in range(SolarSystem.NUM_RINGS):
		if randi()%4 == 0:
			ss.rings[i].append("P" + str(nextPid))
			nextPid += 1
		else:
			ss.rings[i].append(".")
	
	ss.Save(slot)
	
	var ring = 0
	for r in ss.rings:
		if "P" in r[0]:
			var p = r[0]
			p.erase(0, 1)
			p = int(p)
			planets.append([p, sId, ring, slot])
			#planetGenerator.GeneratePlanet(p, sId, ring, slot)
		ring += 1
	
	emit_signal("completedSS", planets)
	
	return nextPid

func GenerateSystem(x, y, sId, nextPid, slot):
	var ss = SolarSystem.new()
	
	ss.ssId = sId
	ss.ssName = "System" + str(sId) #ssystems get a real name when claimed by a Faction
	ss.xPos = x
	ss.yPos = y
	ss.sunColor = sunColors[randi() % len(sunColors)]
	for i in range(SolarSystem.NUM_RINGS):
		if randi()%4 == 0:
			ss.rings[i].append("P" + str(nextPid))
			nextPid += 1
		else:
			ss.rings[i].append(".")
	
	ss.Save(slot)
	
	var ring = 0
	for r in ss.rings:
		if "P" in r[0]:
			var p = r[0]
			p.erase(0, 1)
			p = int(p)
			planetGenerator.GeneratePlanet(p, sId, ring, slot)
		ring += 1
	
	emit_signal("completedSS")
	
	return nextPid
