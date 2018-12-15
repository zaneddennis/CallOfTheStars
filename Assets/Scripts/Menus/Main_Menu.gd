extends Node2D

var Miscellaneous = preload("res://Assets/Scripts/Utility/Miscellaneous.gd")
var misc

func _ready():
	misc = Miscellaneous.new()


func _on_NewGame_Button_pressed():
	hide()
	get_parent().get_node("NewGame_Menu").show()

func _on_Exit_Button_pressed():
	get_tree().quit()

func _on_LoadGame_Button_pressed():
	hide()
	get_parent().get_node("LoadGame_Menu").show()

func _on_Test_Button_pressed():
	var PlanetGenerator = load("res://Assets/Scripts/Generation/PlanetGenerator.gd")
	var pg = PlanetGenerator.new()
	
	var heightmap = pg.GenerateHeightmap(6, 12, 12, 8, 4, 4)
	var surfacemap = pg.GenerateSurfaceMap(heightmap, 7, 6, 2)
	
	print("HEIGHTMAP")
	print(misc.MapToStr(heightmap))
	
	print("SURFACE MAP")
	print(misc.MapToStr(surfacemap))
	
	var tm = $TileMap
	for x in range(24):
		for y in range(16):
			var surface = pg.surfaces[surfacemap[x][y]].to_lower()
			var tilename = ""
			if surface == "water":
				tilename = surface + "_open_0"
			else:
				tilename = surface + "_flat_full__0"
			var tId = tm.tile_set.find_tile_by_name(tilename)
			tm.set_cell(x, y, tId)
	
