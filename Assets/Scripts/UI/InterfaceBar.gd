extends HBoxContainer

var ih

func _ready():
	ih = get_parent().get_parent().get_node("InputHandler")


func _on_Button7_pressed():
	ih.ActionBar("7")
