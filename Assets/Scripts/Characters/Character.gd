extends Node2D


var ag

export var cId = -1

# basic info
export var first = ""
export var last = ""
export var sex = "M"
export var age = 0

# game status
export var inArea = false
export var inShip = -1  # if in ship, this variable is the shipId
var currentShip

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
	else:
		$Sprite.visible = false
