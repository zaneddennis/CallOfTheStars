extends Node2D

var slot_LE
var ag

func _ready():
	slot_LE = $LG_Background/SlotName_LineEdit
	ag = get_tree().root.get_node("Base/ActiveGame")

func _on_LG_Button_pressed():
	var slot = slot_LE.text
	
	print("Loading game from slot " + slot)
	var message = ag.Load([slot, self])
	#print(message)
	
	if message == "success":
		hide()
	else:
		$LG_Background/SlotError_Label.text = message
