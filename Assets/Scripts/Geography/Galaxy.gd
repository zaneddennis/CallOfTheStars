extends Node2D

var GalacticTile = preload("res://Assets/Scripts/Geography/GalacticTile.gd")
var SolarSystem = preload("res://Assets/Scripts/Geography/SolarSystem.gd")
var Planet = preload("res://Assets/Scripts/Geography/Planet.gd")

var ag

var galTilemap = []

var galTiles = []
var sSystems = []
var planets = []

func _ready():
	ag = get_parent()
	
	for x in range(24):
    	galTiles.append([])
    	for y in range(24):
        	galTiles[x].append(null)

func Load(slot):
	for x in range(24):
		galTilemap.append([])
		for y in range(24):
			galTilemap[x].append(0)
	
	var galFile = File.new()
	galFile.open("user://SaveFiles/" + slot + "/galaxy.txt", File.READ)
	
	for y in range(24):
		var line = galFile.get_line()
		for x in range(24):
			galTilemap[x][y] = line[x]
			galTiles[x][y] = GalacticTile.Load("user://SaveFiles/" + ag.slot + "/gTile" + str(x) + "_" + str(y) + ".txt")
	
	for i in range(24):
		var ss = SolarSystem.Load("user://SaveFiles/" + ag.slot + "/ssystem" + str(i) + ".txt")
		sSystems.append(ss)
	
	var i = 0
	while File.new().file_exists("user://SaveFiles/" + ag.slot + "/planet" + str(i) + ".txt"):
		var p = Planet.Load("user://SaveFiles/" + ag.slot + "/planet" + str(i) + ".txt")
		planets.append(p)
		i += 1
	