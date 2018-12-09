extends TextureProgress

var ag
var player

func _ready():
	ag = get_parent().get_parent()
	player = ag.get_node("Characters/Player")

func _process(delta):
	if player.currentShip:
		value = player.currentShip.throttle
