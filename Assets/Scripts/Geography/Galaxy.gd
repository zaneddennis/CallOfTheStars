extends Node2D

var galTilemap = []

func _ready():
	pass

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
	
	#for a in galTilemap:
	#	print(a)