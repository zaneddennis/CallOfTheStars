extends Node2D

func _ready():
	pass


func _on_NewGame_Button_pressed():
	hide()
	get_parent().get_node("NewGame_Menu").show()

func _on_Exit_Button_pressed():
	get_tree().quit()

func _on_LoadGame_Button_pressed():
	hide()
	get_parent().get_node("LoadGame_Menu").show()

func _on_Test_Button_pressed():
	#var firstNamerM = get_node("/root/Base/Utilities/MarkovNamers/CharacterNamers/EnglishFirstNamerM")
	#var firstNamerF = get_node("/root/Base/Utilities/MarkovNamers/CharacterNamers/EnglishFirstNamerF")
	#var lastNamer = get_node("/root/Base/Utilities/MarkovNamers/CharacterNamers/EnglishLastNamer")
	#print(firstNamerF.Generate() + " " + lastNamer.Generate())
	
	var locNamer = get_node("/root/Base/Utilities/MarkovNamers/LocationNamers/EnglishLocationNamer")
	for i in range(10):
		print(locNamer.Generate())
