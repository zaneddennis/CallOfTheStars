extends Node2D

var Planet = preload("res://Assets/Scripts/Geography/Planet.gd")

var pilot = -1
export var sId = -1

export var size = ""
export var blueprint = ""  # takes a blueprint string

export var inArea = false

var throttle = 0
var velocity = Vector2(0, 0)
var maxSpeed = 500

var overPlanet = ""
var orbitingPlanet = ""

func _ready():
	pass

func _process(delta):
	if inArea:
		HandleMovement(delta)
		#UpdateStatus()

func HandleMovement(delta):
	if throttle > 100:
		throttle = 100
	elif throttle < 0:
		throttle = 0
	
	var speed = (float(throttle)/100.0) * maxSpeed
	velocity = polar2cartesian(speed, rotation-(PI/2))
	translate(velocity * delta)

#func UpdateStatus():
#	pass

func Build():
	for p in blueprint.split(","):
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

func Orbit():
	throttle = 0
	velocity = Vector2(0, 0)
	orbitingPlanet = overPlanet

func LeaveOrbit():
	orbitingPlanet = ""

func _on_Orbiter_Area2D_area_entered(area):
	if area.get_parent() is Planet:
		var planet = area.get_parent()
		overPlanet = planet.planetName

func _on_Orbiter_Area2D_area_exited(area):
	if area.get_parent() is Planet:
		overPlanet = ""
