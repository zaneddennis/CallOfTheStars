extends Node2D

func _ready():
	randomize()
	
	OS.center_window()
	position = OS.window_size/2
	
	get_tree().paused = true

func _process(delta):
	OS.center_window()
	position = OS.window_size/2