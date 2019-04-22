extends Node2D


var ag

export var cId = -1

# basic info
export var first = "John"
export var last = "Doe"
export var sex = "M"
export var age = 0

# game status
export var inArea = false  # if in same active space as player (i.e. both in space in same GT or both on land in same PT)
export var inShip = -1  # if in ship, this is the shipId (-1 indicates not in a ship)
var currentShip

var velocity = Vector2(0, 0)
const CHAR_SPEED = 192

func _ready():
	ag = get_parent().get_parent()

func _process(delta):
	if inArea:
		if inShip >= 0:
			$Sprite.visible = false
			currentShip = ag.get_node("Ships").get_children()[inShip]
			
			position = currentShip.position
			rotation = currentShip.rotation
		else:
			$Sprite.visible = true
			currentShip = null
			
			position += delta * CHAR_SPEED * velocity
	else:
		$Sprite.visible = false
