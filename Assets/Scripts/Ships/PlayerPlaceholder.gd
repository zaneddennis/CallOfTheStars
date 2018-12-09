extends Sprite

# the stuff in this script will be taken care of in the ship, not the player
# ships have their own velocity/etc values; NPC FlightAIs give instructions the same way Player's InputManager will

var velocity

export var maxSpeed = 300

func _ready():
	pass

func _process(delta):
	
	"""var throttle = get_parent().get_node("FlightHUD_CanvasLayer/Throttle_TextureProgress").value
	var speed = (throttle/100) * maxSpeed
	velocity = polar2cartesian(speed, rotation-(PI/2))
	translate(velocity * delta)"""
	pass