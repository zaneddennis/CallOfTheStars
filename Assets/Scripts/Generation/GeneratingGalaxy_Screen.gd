extends Node2D

#warning-ignore-all:unused_variable

#signal ptProgress


var GAL_SIZE = 24
var NUM_S_SYSTEMS = 24

var SSGenerator
var PlanetGenerator
var PTGenerator

var GalacticTile = load("res://Assets/Scripts/Geography/GalacticTile.gd")
var ActiveGame = load("res://Assets/Scripts/Utility/ActiveGame.gd")

var slotName_LE

var thread = Thread.new()

var gal
var pTuples = []
var planets = []
var ptProgress = 0

func _ready():
	SSGenerator = get_node("SSGenerator")
	PlanetGenerator = $PlanetGenerator
	PTGenerator = $PTGenerator
	
	slotName_LE = get_node("GG_Background/SlotName_LineEdit")

func _process(delta):
	pass


func GenerateGalaxySeq(slot):
	print("Generating Galaxy...")
	
	gal = []
	for i in range(GAL_SIZE):
		gal.append([])
		for j in range(GAL_SIZE):
			gal[i].append(0)
	
	#PutSupermassive(gal)
	PlaceNebulas(gal)
	PlaceBlackHoles(gal)
	PlaceSSystems(gal)
	
	var galSaveString = ""
	for j in range(GAL_SIZE):
		for i in range(GAL_SIZE):
			galSaveString += str(gal[i][j])
		galSaveString += "\n"
	
	SaveGalaxy(galSaveString, slot)
	
	call_deferred("GalaxyComplete")

func GalaxyComplete():
	thread.wait_to_finish()
	
	$GG_Background/Progress_Label.text = "Generating Solar Systems..."
	$GG_Background/ProgressBar.value = 0
	
	thread = Thread.new()
	thread.start(self, "GenerateSolarSystems", slotName_LE.text)

func GenerateSolarSystems(slot):
	var nextSId = 0
	var nextPId = 0
	for j in range(GAL_SIZE):
		for i in range(GAL_SIZE):
			var t = GalacticTile.new(i, j, gal[i][j], -1, "black", 1024)
			if gal[i][j] == 1:
				t.ssId = nextSId
				print("Generating SS" + str(nextSId))
				nextPId = SSGenerator.GenerateSystemSeq(i, j, nextSId, nextPId, slot)
				nextSId += 1
			t.Save(slot)
	
	call_deferred("SolarSystemsComplete")

func SolarSystemsComplete():
	thread.wait_to_finish()
	
	$GG_Background/Progress_Label.text = "Generating Planets..."
	$GG_Background/ProgressBar.value = 0
	
	thread = Thread.new()
	thread.start(self, "GeneratePlanets", slotName_LE.text)

func GeneratePlanets(slot):
	for p in pTuples:
		planets.append(PlanetGenerator.GeneratePlanetSeq(p[0], p[1], p[2], p[3]))
	
	call_deferred("PlanetsComplete")

func PlanetsComplete():
	thread.wait_to_finish()
	
	#EverythingComplete()
	$GG_Background/Progress_Label.text = "Generating Planetary Tiles..."
	$GG_Background/ProgressBar.value = 0
	
	thread = Thread.new()
	thread.start(self, "GeneratePTilesV3", slotName_LE.text)

func GeneratePTilesV3(slot):
	var planet = planets[ptProgress]
	print("Generating PTiles for Planet ", ptProgress)
	
	for y in range(16):
		for x in range(24):
			planet.tiles[x][y] = PTGenerator.GeneratePT(x, y, planet)
	
	planet.Save(slot)
	
	call_deferred("PTilesComplete")

func PTilesComplete():
	thread.wait_to_finish()
	print("Finished PTiles for Planet ", ptProgress)
	$GG_Background/ProgressBar.value += 100.0 / float(len(pTuples))
	ptProgress += 1
	
	if ptProgress < len(pTuples):
		thread = Thread.new()
		thread.start(self, "GeneratePTilesV3", slotName_LE.text)
	else:
		EverythingComplete()

func EverythingComplete():
	$GG_Background/ProgressBar.value = 100
	$GG_Background/Progress_Label.text = "Done with everything? I think?"
	
	var ag = ActiveGame.new()
	ag.Initialize("v0.01", slotName_LE.text)
	ag.Save(slotName_LE.text)
	$GG_Background/BeginGame_Button.show()

func PutSupermassive(gal):
	var rows = GAL_SIZE/6
	var width = 2
	
	var startX = GAL_SIZE/2 - 1
	var startY = GAL_SIZE/2 - rows/2
	
#warning-ignore:unused_variable
	for r in range(rows/2):
		for w in range(width):
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
		
		var nebula = [Vector2(seedX, seedY)]
		var nSize = 3 + randi()%6
		for i in range(nSize):
			var from = nebula[randi()%len(nebula)]
			var new = Vector2(from.x + (-1 + randi()%3), from.y + (-1 + randi()%3))
			new.x = clamp(new.x, 0, GAL_SIZE-1)
			new.y = clamp(new.y, 0, GAL_SIZE-1)
			
			if gal[new.x][new.y] == 0:
				gal[new.x][new.y] = 2

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
	
	if Directory.new().dir_exists("user://SaveFiles"):
		pass
	else:
		Directory.new().make_dir("user://SaveFiles")
	
	var errorMessage = get_node("GG_Background/SlotError_Label")
	if slotName_LE.text == "":
		errorMessage.text = "Slot name cannot be blank."
	elif Directory.new().dir_exists("user://SaveFiles/" + slotName_LE.text):
		errorMessage.text = "Slot name already taken!"
	else:
		Directory.new().make_dir("user://SaveFiles/" + slotName_LE.text)
		
		slotName_LE.hide()
		errorMessage.hide()
		get_node("GG_Background/GG_Button").hide()
		
		if not thread.is_active():
			thread.start(self, "GenerateGalaxySeq", slotName_LE.text)
			$GG_Background/Progress_Label.text = "Generating Galaxy..."

func SaveGalaxy(content, slot):
	var galSaveFile = File.new()
	galSaveFile.open("user://SaveFiles/" + slot + "/galaxy.txt", galSaveFile.WRITE)
	galSaveFile.store_line(content)
	galSaveFile.close()

func _on_BeginGame_Button_pressed():
	$GG_Background/BeginGame_Button.hide()
	
	var activeGame = get_parent().get_parent().get_node("ActiveGame")
	thread = Thread.new()
	thread.start(activeGame, "Load", [slotName_LE.text, self])

func LoadComplete():
	thread.wait_to_finish()
	
	get_parent().hide()

func _on_SSGenerator_completedSS(p):
	$GG_Background/ProgressBar.value += 100.0/24.0
	pTuples += p

func _on_PlanetGenerator_completedPlanet():
	$GG_Background/ProgressBar.value += 100.0/float(len(pTuples))
