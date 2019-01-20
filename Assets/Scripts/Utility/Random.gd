extends Node

func _ready():
	pass

func IrwinHall(mean, sd, clampMin=null, clampMax=null):
	var vals = []
	for i in range(12):
		vals.append(randf())
	
	var v = 0.0
	for u in vals:
		v += u
	v -= 6.0
	v = (v * sd) + mean
	
	if clampMin and clampMax:
		v = clamp(v, clampMin, clampMax)
	
	return v
