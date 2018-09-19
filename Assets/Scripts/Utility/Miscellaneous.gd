extends Node

func _ready():
	randomize()

#input is {choice0 : count, choice1: count}
func WeightedRandomChoice(choices):
	var choiceList = []
	
	for c in choices:
		for i in range(choices[c]):
			choiceList.append(c)
	
	#print(choiceList)
	return choiceList[randi()%len(choiceList)]

func RandomVector2(bounds):
	var x = randi() % int(bounds.x)
	var y = randi() % int(bounds.y)
	return Vector2(x, y)