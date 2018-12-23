extends Node2D

var Miscellaneous = preload("res://Assets/Scripts/Utility/Miscellaneous.gd")
var misc

func _ready():
	misc = Miscellaneous.new()


func _on_NewGame_Button_pressed():
	hide()
	get_parent().get_node("NewGame_Menu").show()

func _on_Exit_Button_pressed():
	get_tree().quit()

func _on_LoadGame_Button_pressed():
	hide()
	get_parent().get_node("LoadGame_Menu").show()

func _on_Test_Button_pressed():
	pass
	
