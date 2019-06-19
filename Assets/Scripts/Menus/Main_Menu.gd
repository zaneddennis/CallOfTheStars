extends Node2D


var misc
var rand


func _ready():
	misc = get_tree().root.get_node("Base/Utilities/Miscellaneous")
	rand = get_tree().root.get_node("Base/Utilities/Random")


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
