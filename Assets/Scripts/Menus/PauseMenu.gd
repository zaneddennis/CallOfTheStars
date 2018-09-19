extends CanvasLayer

func _ready():
	pass


func _on_Quit_Button_pressed():
	get_tree().quit()


func _on_Resume_Button_pressed():
	for n in get_children():
		n.visible = false
	
	get_tree().paused = false


func _on_Save_Button_pressed():
	pass # replace with function body
