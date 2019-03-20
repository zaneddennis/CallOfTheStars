extends Node

var Miscellaneous = preload("res://Assets/Scripts/Utility/Miscellaneous.gd")

var baseSurface
var baseHeight

var heightmap
var surfacemap

func _ready():
	pass

func _init(s, h, hm, sm):
	baseSurface = s
	baseHeight = h
	heightmap = hm
	surfacemap = sm

func ToSaveStr():
	var s = ""
	
	s += Miscellaneous.MapToStr(heightmap)
	s += Miscellaneous.MapToStr(surfacemap)
	
	return s
