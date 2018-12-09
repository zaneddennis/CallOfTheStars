extends ColorRect

func _ready():
	pass

func _process(delta):
	if visible:
		CheckPlayer()

func ActivateSectorMap(gt, planets):
	Clear()
	
	if gt.gtType == 0:
		#$SectorName_Label.text = "DEEP SPACE"
		$SectorMap_CR/SectorName_Label.text = "DEEP SPACE"
		$SectorMap_CR/Sun.visible = false
	elif gt.gtType == 1:
		#$SectorName_Label.text = "UNSETTLED SYSTEM"
		$SectorMap_CR/SectorName_Label.text = "UNSETTLED SYSTEM"
		$SectorMap_CR/Sun.visible = true
		
		for p in planets:
			var pSprite = Sprite.new()
			$SectorMap_CR.add_child(pSprite)
			pSprite.texture = load("res://Assets/Art/Icons/SectorMap/PlanetUnsettled.png")
			pSprite.position = (p.position-Vector2(8192, 8192)) / 64
			pSprite.position += ($SectorMap_CR.get_rect().size/2)
			pSprite.name = "PLANET_ICON"
	
	$SectorMap_CR/Player.visible = true
	$SectorMap_CR/SectorName_Label.visible = true

func Clear():
	for n in $SectorMap_CR.get_children():
		if "PLANET_ICON" in n.name:
			n.queue_free()
		else:
			n.visible = false

func CheckPlayer():
	var playerShip = get_parent().get_parent().get_node("Ships/Test_Ship")
	
	$SectorMap_CR/Player.rotation = playerShip.rotation
	$SectorMap_CR/Player.position = (playerShip.position/16384) * 256
	
	if playerShip.overPlanet == "":
		$SectorMap_CR/Orbiting_Label.visible = false
		$SectorMap_CR/EnterOrbit_Label.visible = false
		$SectorMap_CR/Orbit_TextureProgress.visible = false
	else:
		$SectorMap_CR/Orbiting_Label.text = playerShip.overPlanet
		$SectorMap_CR/Orbiting_Label.visible = true
		$SectorMap_CR/EnterOrbit_Label.visible = true
		$SectorMap_CR/Orbit_TextureProgress.visible = true
