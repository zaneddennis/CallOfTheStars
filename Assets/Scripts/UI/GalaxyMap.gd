extends CanvasLayer

var Miscellaneous

var galaxy
var ag

var selectedX
var selectedY

var SSIcon = load("res://Assets/Scenes/Icons/SolarSystemIcon.tscn")
var BHIcon = load("res://Assets/Scenes/Icons/BlackHoleIcon.tscn")
var NIcon = load("res://Assets/Scenes/Icons/NebulaIcon.tscn")

func _ready():
	Miscellaneous = get_tree().get_root().get_node("Base/Utilities/Miscellaneous")
	
	galaxy = get_parent().get_node("Galaxy")
	ag = get_parent()

func _process(delta):
	$GalaxyMap_ColorRect/Map_ColorRect/CurrentGTile.rotation = get_parent().get_node("Ships/Test_Ship").rotation

func SelectTile(x, y):
	selectedX = x
	selectedY = y
	
	$GalaxyMap_ColorRect/Map_ColorRect/Icons/GalTileSelector_Sprite.position = Vector2(16*x, 16*y)
	
	if $GalaxyMap_ColorRect/Map_ColorRect/ValidJumps_TileMap.get_cell(x, y) == 0 and not (Vector2(x, y) == ag.galacticPos):
		$GalaxyMap_ColorRect/LockCoords_Button.show()
	else:
		$GalaxyMap_ColorRect/LockCoords_Button.hide()

	if galaxy.galTilemap[x][y] == "1":
		$GalaxyMap_ColorRect/SystemName_Label.text = "UNCHARTED SYSTEM"
	elif galaxy.galTilemap[x][y] == "2":
		$GalaxyMap_ColorRect/SystemName_Label.text = "NEBULA"
	elif galaxy.galTilemap[x][y] == "4":
		$GalaxyMap_ColorRect/SystemName_Label.text = "BLACK HOLE"
	else:
		$GalaxyMap_ColorRect/SystemName_Label.text = "DEEP SPACE"

func Activate():
	for n in get_children():
		n.visible = true
	SelectTile(ag.galacticPos.x, ag.galacticPos.y)
	
	# set current icon
	$GalaxyMap_ColorRect/Map_ColorRect/CurrentGTile.position = get_parent().galacticPos * 16
	$GalaxyMap_ColorRect/Map_ColorRect/CurrentGTile.position += Vector2(8, 8)
	
	# set valid jumps
	var vjTM = $GalaxyMap_ColorRect/Map_ColorRect/ValidJumps_TileMap
	for x in range(24):
		for y in range(24):
			vjTM.set_cell(x, y, -1)
			
			if galaxy.galTilemap[x][y] in ["0", "1"]:
				if Miscellaneous.Manhattan(Vector2(ag.galacticPos.x, ag.galacticPos.y), Vector2(x, y)) <= ag.JUMP_LIMIT:
					vjTM.set_cell(x, y, 0)

func Initialize():
	for x in range(24):
		for y in range(24):
			if galaxy.galTilemap[x][y] == "1":
				var icon = SSIcon.instance()
				icon.position = Vector2(16*x, 16*y)
				$GalaxyMap_ColorRect/Map_ColorRect/Icons.add_child(icon)
			elif galaxy.galTilemap[x][y] == "2":
				var icon = NIcon.instance()
				icon.position = Vector2(16*x, 16*y)
				$GalaxyMap_ColorRect/Map_ColorRect/Icons.add_child(icon)
			elif galaxy.galTilemap[x][y] == "4":
				var icon = BHIcon.instance()
				icon.position = Vector2(16*x, 16*y)
				$GalaxyMap_ColorRect/Map_ColorRect/Icons.add_child(icon)

func _on_LockCoords_Button_pressed():
	$GalaxyMap_ColorRect.hide()
	ag.EnterGTile(selectedX, selectedY)
