extends Node2D


var GAL_SIZE = 24
var NUM_S_SYSTEMS = 24

var SSGenerator

var GalacticTile = load("res://Assets/Scripts/Geography/GalacticTile.gd")
var ActiveGame = load("res://Assets/Scripts/Utility/ActiveGame.gd")

var slotName_LE

var isGenerating = false
var firstRun = true
var gg = null
var progress = 0

func _ready():
	SSGenerator = get_node("SSGenerator")
	slotName_LE = get_node("GG_Background/SlotName_LineEdit")

#warning-ignore:unused_argument
func _process(delta):
	
	if isGenerating:
		if firstRun:
			gg = GG()
			firstRun = false
		else:
			gg = gg.resume()
			# update progress bar
			progress += 1
			$GG_Background/ProgressBar.value = progress
			
			if typeof(gg) == TYPE_STRING and gg == "finished":
				isGenerating = false
				# move on to begin game

# testing coroutines
func GG():
	for i in range(24):
		OS.delay_msec(500)
		print(i)
		yield()
	return "finished"


func GenerateGalaxy(slot):
	print("Beginning Galaxy Generation...")
	
	var gal = []
	for i in range(GAL_SIZE):
		gal.append([])
#warning-ignore:unused_variable
		for j in range(GAL_SIZE):
			gal[i].append(0)
	
	PutSupermassive(gal)
	
	PlaceNebulas(gal)
	
	PlaceDustClouds(gal)
	
	PlaceBlackHoles(gal)
	
	PlaceSSystems(gal)
	
	var galSaveString = ""
	for j in range(GAL_SIZE):
		for i in range(GAL_SIZE):
			galSaveString += str(gal[i][j])
		galSaveString += "\n"
	
	SaveGalaxy(galSaveString, slot)
	
	var nextSId = 0
	var nextPId = 0
	for j in range(GAL_SIZE):
		for i in range(GAL_SIZE):
			var t = GalacticTile.new(i, j, gal[i][j], -1, "black", 1024)
			if gal[i][j] == 1:
				t.ssId = nextSId
				nextPId = SSGenerator.GenerateSystem(i, j, nextSId, nextPId, slot)
				nextSId += 1
			t.Save(slot)


func PutSupermassive(gal):
	var rows = GAL_SIZE/6
	var width = 2
	
	var startX = GAL_SIZE/2 - 1
	var startY = GAL_SIZE/2 - rows/2
	
#warning-ignore:unused_variable
	for r in range(rows/2):
		for w in range(width):
			#print(startX+w, startY+r)
			gal[startX+w][startY] = 5
		width += 2
		startX -= 1
		startY += 1
	
	startX = GAL_SIZE/2 - rows/2
	startY = GAL_SIZE/2
	width = rows
#warning-ignore:unused_variable
	for r in range(rows/2):
		for w in range(width):
			gal[startX+w][startY] = 5
		width -= 2
		startX += 1
		startY += 1

func PlaceSSystems(gal):
#warning-ignore:unused_variable
	for i in range(NUM_S_SYSTEMS):
		var x = randi()%GAL_SIZE
		var y = randi()%GAL_SIZE
		
		while gal[x][y] != 0:
			x = randi()%GAL_SIZE
			y = randi()%GAL_SIZE
		
		gal[x][y] = 1

func PlaceNebulas(gal):
	var seeds = 3 + randi()%3
	
#warning-ignore:unused_variable
	for s in range(seeds):
		var seedX = randi()%GAL_SIZE
		var seedY = randi()%GAL_SIZE
		while gal[seedX][seedY] != 0:
			seedX = randi()%GAL_SIZE
			seedY = randi()%GAL_SIZE
		gal[seedX][seedY] = 2
		
#warning-ignore:unused_variable
		var nSize = 3 + randi()%6
		#grow seeds (do later)

func PlaceDustClouds(gal):
	var seeds = 3 + randi()%3
	
#warning-ignore:unused_variable
	for s in range(seeds):
		var seedX = randi()%GAL_SIZE
		var seedY = randi()%GAL_SIZE
		while gal[seedX][seedY] != 0:
			seedX = randi()%GAL_SIZE
			seedY = randi()%GAL_SIZE
		gal[seedX][seedY] = 3
		
#warning-ignore:unused_variable
		var nSize = 2 + randi()%3
		#grow seeds (do later)

func PlaceBlackHoles(gal):
	var seeds = 3 + randi()%3
	
#warning-ignore:unused_variable
	for s in range(seeds):
		var seedX = randi()%GAL_SIZE
		var seedY = randi()%GAL_SIZE
		while gal[seedX][seedY] != 0:
			seedX = randi()%GAL_SIZE
			seedY = randi()%GAL_SIZE
		gal[seedX][seedY] = 4



func _on_GG_Button_pressed():
	
	#$GG_Background/GG_Button.hide()
	
	if Directory.new().dir_exists("user://SaveFiles"):
		pass
	else:
#warning-ignore:return_value_discarded
		Directory.new().make_dir("user://SaveFiles")
	
	var errorMessage = get_node("GG_Background/SlotError_Label")
	if slotName_LE.text == "":
		errorMessage.text = "Slot name cannot be blank."
	elif Directory.new().dir_exists("user://SaveFiles/" + slotName_LE.text):
		errorMessage.text = "Slot name already taken!"
	else:
#warning-ignore:return_value_discarded
		Directory.new().make_dir("user://SaveFiles/" + slotName_LE.text)
		
		slotName_LE.hide()
		errorMessage.hide()
		get_node("GG_Background/GG_Button").hide()
		#get_node("GG_Background/BeginGame_Button").show()
		
		# move GG() to inside _process
		#GenerateGalaxy(slotName_LE.text)
		isGenerating = true
		
		var ag = ActiveGame.new()
		ag.Initialize("v0.01", slotName_LE.text)
		ag.Save(slotName_LE.text)


func SaveGalaxy(content, slot):
	var galSaveFile = File.new()
	#galSaveFile.open("res://SaveFiles/Slot" + str(slot) + "/galaxy" + ".txt", galSaveFile.WRITE)
	galSaveFile.open("user://SaveFiles/" + slot + "/galaxy.txt", galSaveFile.WRITE)
	galSaveFile.store_line(content)
	galSaveFile.close()


func _on_BeginGame_Button_pressed():
	get_parent().hide()
	#get_tree().quit()
	
	var activeGame = get_parent().get_parent().get_node("ActiveGame")
	activeGame.Load(slotName_LE.text)
