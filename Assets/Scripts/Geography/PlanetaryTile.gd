extends Node

#var Miscellaneous = preload("res://Assets/Scripts/Utility/Miscellaneous.gd")

var planetId
var x
var y

var baseSurface
var baseHeight

var heightmap
var surfacemap

func _ready():
	pass

func _init(pId, x_, y_):
	planetId = pId
	x = x_
	y = y_

func ToSaveStr():
	var saveStr = str(planetId) + "\n"
	saveStr += str(x) + " " + str(y) + "\n"
	
	saveStr += str(baseSurface) + "\n"
	saveStr += str(baseHeight) + "\n"
	
	return saveStr

"""func Save(slot):
	var saveStr = str(planetId) + "\n"
	saveStr += str(x) + " " + str(y) + "\n"
	
	saveStr += str(baseSurface) + "\n"
	saveStr += str(baseHeight) + "\n"
	
	var saveFile = File.new()
	saveFile.open("user://SaveFiles/" + slot + "/pt" + str(ptId) + ".txt", saveFile.WRITE)
	saveFile.store_line(saveStr)
	saveFile.close()"""
