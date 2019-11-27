extends Node

signal completedPlanet

var Planet = load("res://Assets/Scripts/Geography/Planet.gd")

#var PlanetaryTileset = load("res://Assets/Art/Tilesets/PlanetaryTileset.tres")
#var PlanetaryBTileset = load("res://Assets/Art/Tilesets/PlanetaryBTiles.tres")
#var BordersTileset = load("res://Assets/Art/Tilesets/PlanetaryBorderTileset.tres")

var nameGen
#var rand
#var ptGenerator

#var xLen = 24
#var yLen = 16

var resources = {"Aluminum_Ore": 0.35, "Chromite": 0.2, "Coal": 0.6, "Copper_Ore": 0.4, "Gold_Ore": 0.2, "Granite": 0.3,
				 "Gypsum_Ore": 0.4, "Iron_Ore": 0.75, "Lead_Ore": 0.4, "Lithium_Ore": 0.2, "Manganese_Ore": 0.25,
				 "Nickel_Ore": 0.25, "Plutonium_Ore": 0.2, "Silicon_Ore": 0.35, "Silver_Ore": 0.25, "Sulfur_Ore": 0.5, "Tin_Ore": 0.35,
				 "Titanium_Ore": 0.3, "Tungsten_Ore": 0.3, "Uranium_Ore": 0.3, "Zinc_Ore": 0.35} # global base rates

# EVERYTHING ABOVE HERE IS OUTDATED
var bgen = BiomeGenerator.new()
var misc = Miscellaneous.new()
var RNG = RandomNumberGenerator.new()

var X_SIZE = 48
var Y_SIZE = 32

var bedrocks = ["Bluestone", "Brownstone", "Granite", "Lavendrite", "Limestone", "Redrock", "Sandstone", "Verdrum", "Whitestone"]

func _ready():
	nameGen = get_node("/root/Base/Utilities/MarkovNamers/LocationNamers/EnglishLocationNamer")
	#rand = get_node("/root/Base/Utilities/Random")
	#ptGenerator = get_parent().get_node("PTGenerator")


func GeneratePlanetSeq(pId, sId, ring, slot):
	print("Generating Planet " + str(pId))
	
	var p = Planet.new()
	p.init(pId, "planet", nameGen.Generate(), "Unsettled", sId, ring)
	p.degreePosition = randi()%360
	p.baseSurface = "Greystone"  # temporary measure until I get new Planet graphics
	
	# basic planet parameters
	p.atmosphere = GenerateAtmo(ring)
	print("Atmosphere: ", p.atmosphere)
	p.temperature = GenerateTemp(ring, p.atmosphere)
	var tFalloff = (randi()%2) if not p.atmosphere else (1 + randi()%4)
	p.moisture = GenerateMoisture(p.temperature)
	p.bedrock = bedrocks[randi()%len(bedrocks)]
	
	# Generate Heightmap
	p.heightmap = GenerateContinents()
	AddHills(p.heightmap)
	AddMountains(p.heightmap)
	
	p.watermap = null
	if p.atmosphere:
		p.oceanCol = GenerateOceanColor()
		p.watermap = GenerateWatermap(p.heightmap)
		AddRivers(p.watermap, p.heightmap, p.moisture)
	
	p.temperatureMap = GenerateTemperatueMap(p.heightmap, tFalloff, p.temperature)
	p.moistureMap = GenerateMoistureMap(p.heightmap, p.watermap, p.moisture)
	
	var bioclusters = FindBioclusters(p.temperatureMap, p.moistureMap, p.heightmap, p.atmosphere)
	var distances = FindBcDistances(bioclusters)
	var collapses = CollapseBioclusters(bioclusters, tFalloff, distances)
	
	var retVal = GenerateBiomeMap(p.temperatureMap, p.moistureMap, p.heightmap, bioclusters, collapses, p)
	p.biomeMap = retVal[0]
	p.biomes = retVal[1]
	
	# generate biome details
	for b in p.biomes:
		bgen.Generate(b)
		print(b.DetailsToStr())
	
	# render planet image
	p.Render(slot)
	
	p.Save(slot)
	
	emit_signal("completedPlanet")
	print("")
	return p

# Primary Generation Functions
func GenerateContinents():
	var m = Map.new(X_SIZE, Y_SIZE)
	
	# Roll for parameters
	var lRatio = rand_range(0.2, 0.8)
	var initials = 30 + randi()%11
	var smoothness = 1 + randi()%30
	var mutRate = rand_range(0.001, 0.15)
	
	var points = RandomPoints(initials)
	for i in range(initials):
		var p = points[i]
		if i < lRatio*initials:
			m.Set(p.x, p.y, 1)
		else:
			m.Set(p.x, p.y, 0)
	
	var vPoints = RandomPoints(2000/smoothness)
	for v in vPoints:
		var best = 0
		var bestDist = 9999
		for i in range(len(points)):
			var d = m.EuclideanSq(v, points[i])
			if d <= bestDist:
				bestDist = d
				best = i
	
		var h = m.Get(points[best].x, points[best].y)
		var muts = [1, 0]
		if randf() < mutRate:
			h = muts[h]
		m.Set(v.x, v.y, h)
	
	for x in range(48):
		for y in range(32):
			var closest = m.ClosestLS_Mult(Vector2(x, y))
			var h = m.Get(closest.x, closest.y)
			m.Set(x, y, h)
	
	return m

func GenerateWatermap(hm):
	var lMax = 3 + randi()%10
	var bodies = []
	var bodymap = Map.new(hm.X_SIZE, hm.Y_SIZE)
	var watermap = Map.new(hm.X_SIZE, hm.Y_SIZE)
	
	for y in range(hm.Y_SIZE):
		for x in range(hm.X_SIZE):
			var h = hm.Get(x, y)
			
			if h == 0:
				if bodies.empty():  # if this is the first water tile on the map
					bodies.append([Vector2(x, y)])
					bodymap.Set(x, y, 0)
				
				else:
					var neighbors = bodymap.Neighbors(x, y)
					var uniques = GetUnique(neighbors, TYPE_INT)
					if len(uniques) == 0:
						bodies.append([Vector2(x, y)])
						bodymap.Set(x, y, len(bodies)-1)
					elif len(uniques) == 1:
						bodies[uniques[0]].append(Vector2(x, y))
						bodymap.Set(x, y, uniques[0])
					elif len(uniques) == 2:
						var minBody = min(uniques[0], uniques[1])
						var maxBody = max(uniques[0], uniques[1])
						for p in bodies[maxBody]:
							bodies[minBody].append(p)
							bodymap.Set(p.x, p.y, minBody)
						bodies[maxBody].clear()
						bodies[minBody].append(Vector2(x, y))
						bodymap.Set(x, y, minBody)
					else:
						assert false
	
	for b in bodies:
		if len(b) <= lMax:  # if lake
			for p in b:
				#hm.Set(p.x, p.y, "*")
				watermap.Set(p.x, p.y, 5)
		else:
			for p in b:
				watermap.Set(p.x, p.y, 0)
	
	return watermap

func GenerateTemperatueMap(hm, f, baseTemp):
	var bMax = (hm.Y_SIZE/2) - 2
	var breakpoints = []
	if f > 0:
		breakpoints.append(1 + randi()%(bMax-(f-1)))
		for i in range(f-1):
			var last = breakpoints[i]
			breakpoints.append(RNG.randi_range(last+1, bMax-(f - len(breakpoints) - 1)))
	
	bMax = hm.Y_SIZE - 1
	for b in breakpoints.duplicate():
		breakpoints.append(bMax-b)
	
	var tempMap = Map.new(hm.X_SIZE, hm.Y_SIZE)
	var latTemp = baseTemp - f
	for y in range(hm.Y_SIZE):
		if y in breakpoints:
			if y < hm.Y_SIZE/2:  # northern hemisphere
				latTemp += 1
			else:  # southern hemisphere
				latTemp -= 1
		for x in range(hm.X_SIZE):
			tempMap.Set(x, y, latTemp)
			
			if y in breakpoints:
				if y < hm.Y_SIZE/2:  # northern hemisphere
					if randi()%4 == 0:
						tempMap.Set(x, y, latTemp-1)
				else:  # southern hemisphere
					if randi()%4 != 0:
						tempMap.Set(x, y, latTemp+1)
			
			var alt = hm.Get(x, y)
			if alt == 3:
				tempMap.Set(x, y, clamp(tempMap.Get(x, y)-randi()%2, 0, 20))
			elif alt == 4:
				tempMap.Set(x, y, clamp(tempMap.Get(x, y)-1, 0, 20))
			elif alt == 5:
				tempMap.Set(x, y, clamp(tempMap.Get(x, y)-2, 0, 20))
	
	return tempMap

func GenerateMoistureMap(hm, wm, baseM):
	var mm = Map.new(hm.X_SIZE, hm.Y_SIZE)
	
	for x in range(mm.X_SIZE):
		for y in range(mm.Y_SIZE):
			mm.Set(x, y, baseM)
			
			if wm and baseM > 0 and hm.Get(x, y) != 0:
				if 0 in wm.Neighbors(x, y):  # on coast
					mm.Set(x, y, clamp(baseM+1+randi()%2, 1, 5))
				elif 1 in wm.Neighbors(x, y):  # next to Lake (TODO: Rivers)
					mm.Set(x, y, clamp(baseM+randi()%2, 1, 5))
			elif baseM > 0 and hm.Get(x, y) == 0:  # is water
				mm.Set(x, y, 5)
	
	return mm

func GenerateBiomeMap(tm, mm, hm, bioclusters, collapses, p):
	var biomes = []
	var bm = Map.new(hm.X_SIZE, hm.Y_SIZE)
	
	var bcRem = range(len(bioclusters))
	for c in collapses:
		bcRem.erase(c)
	for b in bcRem:
		biomes.append(Biome.new(p, bioclusters[b][0], bioclusters[b][1], bioclusters[b][2]))
	
	for x in range(bm.X_SIZE):
		for y in range(bm.Y_SIZE):
			var bc = Vector3(tm.Get(x, y), mm.Get(x, y), hm.Get(x, y))
			var bcId = bioclusters.find(bc)
			while bcId in collapses:
				bcId = collapses[bcId]
			var biome = bcRem.find(bcId)
			if biome != -1:
				bm.Set(x, y, biome)
	
	return [bm, biomes]


# Adder Functions
func AddHills(hm):
	var numSeeds = randi()%16
	var hSeeds = RandomPoints(numSeeds)
	
	for s in hSeeds:
		var points = [s]
		hm.Set(s.x, s.y, hm.Get(s.x, s.y)+1)
		
		var hSize = randi()%32
		for i in range(hSize):
			var p = points[randi()%len(points)].abs()  # using abs() to create a copy
			p.x += -1 + randi()%3
			p.y += -1 + randi()%3
			if randi()%2 == 0:
				hm.Set(p.x, p.y, hm.Get(wrapi(p.x, 0, hm.X_SIZE), clamp(clamp(p.y, 0, hm.Y_SIZE-1)+1, 0, 4)))
			points.append(p)

func AddMountains(hm):
	var numRanges = randi()%16
	var mSeeds = RandomPoints(numRanges)
	
	for s in mSeeds:
		if hm.Get(s.x, s.y) == 1:
			hm.Set(s.x, s.y, 4)
			for x in range(-1, 2):
				for y in range(-1, 2):
					if abs(x + y) == 1 and hm.Get(s.x + x, s.y + y) == 1:
						if randf() < 0.3:
							hm.Set(s.x + x, s.y + y, 2)
						else:
							hm.Set(s.x + x, s.y + y, 3)
			
			# pick direction and parameters
			var dir = rand_range(0, 2*PI)
			var xProb = cos(dir)
			var yProb = sin(dir)
			var length = 1 + randi()%15
			
			var curr = s
			for i in range(length):
				var velocity = Vector2(0, 0)
				var xRoll = randf()
				var yRoll = randf()
				
				if xRoll < abs(xProb):
					velocity.x = int(sign(xProb))
				if yRoll < abs(yProb):
					velocity.y = int(sign(yProb))
				
				var next = curr + velocity
				if typeof(hm.Get(next.x, next.y)) == TYPE_INT and hm.Get(next.x, next.y) > 0:
					hm.Set(next.x, next.y, 4)
					
					for x in range(-1, 2):
						for y in range(-1, 2):
							if abs(x + y) == 1 and str(hm.Get(next.x + x, next.y + y)) == "1":
								if randf() < 0.2:
									hm.Set(next.x + x, next.y + y, 2)
								else:
									hm.Set(next.x + x, next.y + y, 3)
					
					curr = next
				
				else:
					break

func AddRivers(wm, hm, m):
	var numSeeds = randi()%(m*2)
	print(numSeeds, "seeds")
	var rSeeds = []
	for i in range(numSeeds):
		var x = 1 + randi()%46
		var y = 1 + randi()%30
		
		var numAttempts = 0
		var gaveUp = false
		while hm.Get(x, y) < 2:
			x = 1 + randi()%46
			y = 1 + randi()%30
			numAttempts += 1
			if numAttempts > 10000:
				gaveUp = true
				break
		
		if not gaveUp:
			rSeeds.append(Vector2(x, y))
		else:
			print("Gave up")
	
	for s in rSeeds:
		print("RIVER CREATED")
		var curr = s
		var currPoints = []
		
		while true:
			var hNeighbors = hm.Neighbors(curr.x, curr.y, currPoints)
			print(hNeighbors)
			var wNeighbors = wm.Neighbors(curr.x, curr.y, currPoints)
			var nToNum = {0:7, 1:8, 2:9, 3:6, 4:3, 5:2, 6:1, 7:4}
			var nToDir = {0: Vector2(-1,-1), 1: Vector2(0,-1), 2: Vector2(1,-1),
							3: Vector2(1,0), 4: Vector2(1,1), 5: Vector2(0,1),
							6: Vector2(-1,1), 7: Vector2(-1,0)}
			
			# check exit conditions
			
			if 0 in hNeighbors:  # if meets ocean or lake
				var ix = hNeighbors.find(0)
				wm.Set(curr.x, curr.y, nToNum[ix])  # point towards ocean/lake
				currPoints.append(curr)
				break
			
			var union = []
			for n in wNeighbors:
				if n in [7, 8, 9, 6, 3, 2, 1, 4]:
					union.append(n)
			if len(union) >= 1:  # if meets existing river
				var other = union[randi()%len(union)]
				var ix = wNeighbors.find(other)
				wm.Set(curr.x, curr.y, nToNum[ix])  # point towards ocean/lake
				currPoints.append(curr)
				break
			
			# pick direction
			
			# find all instances of lowest altitude (not already part of river)
			var mVal = 999
			var mList = []
			var i = 0
			for n in hNeighbors:  # TODO: skip points already in river
				# if not already in river
				
				if n and  n < mVal:
					mList.clear()
					mVal = n
					mList.append(i)
				elif n == mVal:
					mList.append(i)
				i += 1
			
			# pick a direction from lowests
			var nextN = mList[randi()%len(mList)]
			var next = nToDir[nextN] + curr
			
			# set direction in wm, reset curr
			wm.Set(curr.x, curr.y, nToNum[nextN])
			currPoints.append(curr)
			curr = next
		print("===")


# Subgeneration Functions
func GenerateAtmo(r):
	if r <= 2:
		if randi()%4==0:
			return true
	elif r <= 6:
		if randi()%2==0:
			return true
	else:
		if randi()%4==0:
			return true
	
	return false

func GenerateTemp(r, a):
	if a:
		return GenerateTempAtmo(r)
	else:
		return GenerateTempNoAtmo(r)

func GenerateTempAtmo(r):
	if r <= 2:
		return 12 + randi()%3
	elif r <= 4:
		return 10 + randi()%5
	elif r <= 6:
		return 8 + randi()%7
	elif r <= 9:
		return 6 + randi()%5
	else:
		return 5 + randi()%4

func GenerateTempNoAtmo(r):
	if r <= 5:
		return 15 + randi()%6
	else:
		return 1 + randi()%4

func GenerateMoisture(t):
	if t >= 15:  # no atmo hot
		return 0
	elif t >= 5:  # atmo
		return 1 + randi()%5
	else:  # no atmo cold
		return randi()%2

# returns a list of Biocluster tuples as [Vector3(temp, moist, alt)]
func FindBioclusters(tm, mm, hm, atmo):
	var clusters = []
	for x in range(hm.X_SIZE):
		for y in range(hm.Y_SIZE):
			var bc = Vector3(tm.Get(x, y), mm.Get(x, y), hm.Get(x, y))
			if (hm.Get(x, y) != 0 or !atmo) and not bc in clusters:
				clusters.append(bc)
	return clusters

func FindBcDistances(clusters):
	var result = {}
	
	for i in range(len(clusters)):
		for j in range(i+1, len(clusters)):
			var d = misc.Manhattan3(clusters[i], clusters[j])
			if not d in result:
				result[d] = []
			result[d].append([i,j])
	
	return result

# returns "collapses" dict
func CollapseBioclusters(clusters, falloff, distances):
	var result = {}
	
	while len(clusters) - len(result) > falloff+1:
		var distKeys = distances.keys()
		distKeys.sort()
		var minDist = distKeys[0]
		
		var pair = distances[minDist][randi()%len(distances[minDist])]
		var collapser = randi()%2
		result[pair[collapser]] = pair[{0:1,1:0}[collapser]]
		
		for d in distKeys:
			var dList = distances[d]
			var i = 0
			while i < len(dList):
				if pair[collapser] in dList[i]:
					dList.remove(i)
				else:
					i += 1
			if len(dList) == 0:
				distances.erase(d)
	
	return result

func GenerateOceanColor():
	var col = Color(0, 0, 0, 1.0)
	col.r = rand_range(0.0, 0.7)
	col.g = rand_range(0.2, 0.9)
	col.b = rand_range(0.5, 1.0)
	return col


# Utility Functions
func RandomPoints(n):
	var results = []
	for i in range(n):
		var x = randi()%48
		var y = randi()%32
		results.append(Vector2(x, y))
	return results

func GetUnique(arr, type):
	var results = []
	for a in arr:
		if typeof(a) == type and not a in results:
			results.append(a)
	return results
