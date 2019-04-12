extends Node2D

var slot_LE
var ag

var thread

func _ready():
	slot_LE = $LG_Background/SlotName_LineEdit
	ag = get_tree().root.get_node("Base/ActiveGame")

func _on_LG_Button_pressed():
	var slot = slot_LE.text
	
	$LG_Background/LG_Button.hide()
	$LG_Background/ProgressBar.show()
	
	thread = Thread.new()
	thread.start(ag, "Load", [slot, self])

func LoadComplete(message):
	thread.wait_to_finish()
	print(message)
	hide()

func LoadFailed(message):
	thread.wait_to_finish()
	print(message)
	
	$LG_Background/ProgressBar.hide()
	$LG_Background/LG_Button.show()
	$LG_Background/SlotError_Label.text = message

func _on_Galaxy_loadPlanet():
	$LG_Background/ProgressBar.value += 100.0/70.0
