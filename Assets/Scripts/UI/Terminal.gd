extends ColorRect

func _ready():
	pass

func _process(delta):
	if visible:
		#var player = get_parent().get_parent().get_node("PlayerPlaceholder")
		var playerShip = get_parent().get_parent().get_node("Ships/Test_Ship")
		
		$SectorMap_CR/Player.rotation = playerShip.rotation
		$SectorMap_CR/Player.position = (playerShip.position/16384) * 256

func Activate(gt, planets):
	Clear()
	
	if gt.gtType == 0:
		$SectorName_Label.text = "DEEP SPACE"
		$SectorMap_CR/Sun.visible = false
	elif gt.gtType == 1:
		$SectorName_Label.text = "UNSETTLED SYSTEM"
		$SectorMap_CR/Sun.visible = true
		
		for p in planets:
			var pSprite = Sprite.new()
			$SectorMap_CR.add_child(pSprite)
			pSprite.texture = load("res://Assets/Art/Icons/SectorMap/PlanetUnsettled.png")
			pSprite.position = (p.position-Vector2(8192, 8192)) / 64
			pSprite.position += ($SectorMap_CR.get_rect().size/2)
	
	$SectorMap_CR/Player.visible = true

func Clear():
	for n in $SectorMap_CR.get_children():
		if n.name in ["Sun", "Player"]:
			n.visible = false
		else:
			n.queue_free()