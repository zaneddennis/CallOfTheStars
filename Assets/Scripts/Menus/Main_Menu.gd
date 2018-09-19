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
	var firstNamer = get_node("/root/Base/Utilities/MarkovNamers/CharacterNamers/EnglishFirstNamerM")
	var lastNamer = get_node("/root/Base/Utilities/MarkovNamers/CharacterNamers/EnglishLastNamer")
	#print(firstNamer.Generate() + " " + lastNamer.Generate())
	for i in range(100):
		print(firstNamer.Generate() + " " + lastNamer.Generate())
	
	#print(float(2048) / float(16384))
