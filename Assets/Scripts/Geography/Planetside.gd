extends Node2D

const MAP_SIZE = 64

func _ready():
	pass

func Activate(pt):
	show()
	
	var tm = $Planetside_TileMap
	tm.clear()
	for x in range(MAP_SIZE):
		for y in range(MAP_SIZE):
			tm.set_cell(x, y, 0)
