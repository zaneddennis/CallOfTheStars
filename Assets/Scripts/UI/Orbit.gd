extends CanvasLayer

var ag
var player

func _ready():
	ag = get_parent()
	player = ag.get_node("Characters/Player")

func Activate():
	var planet = ag.get_node("Background_ColorRect/" + player.currentShip.orbitingPlanet)
	
	$Orbit_ColorRect/PlanetName_Label.text = planet.planetName
	$Orbit_ColorRect/FactionName_Label.text = planet.planetOwner
	
	for n in get_children():
		n.visible = true
