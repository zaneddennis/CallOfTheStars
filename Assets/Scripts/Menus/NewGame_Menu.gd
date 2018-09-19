extends Node2D

func _ready():
	pass


func _on_GenerateGalaxy_Button_pressed():
	hide()
	get_parent().hide()
	get_parent().get_parent().get_node("GeneratingGalaxy_Screen").show()
