extends Node2D

var pilot = -1
export var sId = -1

export var size = ""
export var pieces = ""

var throttle = 0
var velocity = Vector2(0, 0)
var maxSpeed = 300

func _ready():
	pass

func _process(delta):
	HandleMovement(delta)

func HandleMovement(delta):
	if throttle > 100:
		throttle = 100
	elif throttle < 0:
		throttle = 0
	
	var speed = (float(throttle)/100.0) * maxSpeed
	velocity = polar2cartesian(speed, rotation-(PI/2))
	translate(velocity * delta)

func build():
	for p in pieces.split(","):
		var splits = p.split("#")
		p = splits[0]
		var x = splits[1]
		var y = splits[2]
		var o = splits[3]
		
		var pScene = load("res://Assets/Scenes/Ships/" + size + "/" + p + ".tscn")
		var piece = pScene.instance()
		add_child(piece)
		piece.position = Vector2(x, y)
		
		for i in range(4):
			var v = o[i]
			var oNode = piece.get_node("Outline" + str(i) + "_Sprite")
			
			if v == "1":
				oNode.visible = true
			elif v == "0":
				oNode.visible = false
			else:
				assert(false)
