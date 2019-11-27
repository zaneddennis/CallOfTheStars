extends Node

class_name Map

var data
var X_SIZE
var Y_SIZE

func _ready():
	pass

func _init(x_, y_):
	X_SIZE = x_
	Y_SIZE = y_
	
	data = []
	data.resize(X_SIZE)
	for x in range(X_SIZE):
		data[x] = []
		data[x].resize(Y_SIZE)
		
		for y in range(Y_SIZE):
			data[x][y] = "."

# unlike Get, crashes on invalid value
# in final version, assert that v is an int
func Set(x, y, v, xWrap=true):
	assert(typeof(v) == TYPE_INT or v == ".")
	
	if xWrap:
		if x < 0:
			x = X_SIZE + x
		elif x >= X_SIZE:
			x = x - X_SIZE
		
		if y < 0:
			y = Y_SIZE + y
		elif y >= Y_SIZE:
			y = y - Y_SIZE
	
	data[x][y] = v

# returns null for any invalid coordinate (makes things a lot simpler with Neighbors())
func Get(x, y, xWrap=true):
	if y < 0 or y >= Y_SIZE:
		return null
	
	if xWrap:
		if x < 0:
			x = X_SIZE + x
		elif x >= X_SIZE:
			x = x - X_SIZE
		return data[x][y]
	else:
		if x < 0 or x >= X_SIZE:
			return null
		else:
			return data[x][y]

func ClosestLS(v):
	var best = null
	var bestDist = null
	for x in range(X_SIZE):
		for y in range(Y_SIZE):
			if typeof(data[x][y]) == TYPE_INT:
				var d = EuclideanSq(v, Vector2(x, y))
				
				if best == null or (best != null and d < bestDist):
					best = Vector2(x, y)
					bestDist = d
	return best

func ClosestLS_Mult(v):
	var best = []
	var bestDist = null
	
	for x in range(X_SIZE):
		for y in range(Y_SIZE):
			if typeof(data[x][y]) == TYPE_INT:
				var d = stepify(EuclideanSq(v, Vector2(x, y)), 0.1)  # stepify so == works
				
				if bestDist == null:
					best = [Vector2(x, y)]
					bestDist = d
				else:
					if d < bestDist:
						best = [Vector2(x, y)]  # I know this is repeated code, but it's for readability
						bestDist = d
					elif d == bestDist:
						best.append(Vector2(x, y))
	
	return best[randi()%len(best)]

func ClosestBFS(v):
	pass

func Neighbors(x, y, wrap=true):
	var neighbors = []
	
	for d in [Vector2(-1, -1),  # NW
	          Vector2(0, -1),  # N
			  Vector2(1, -1),  # NE
			  Vector2(1, 0),  # E
			  Vector2(1, 1),  # SE
			  Vector2(0, 1),  # S
			  Vector2(-1, 1),  # SW
			  Vector2(-1, 0)]:  # W
		neighbors.append(Get(x + d.x, y + d.y, wrap))
	
	assert len(neighbors) == 8
	return neighbors

func EuclideanSq(v1, v2, wrap=true):
	if not wrap:
		return v1.distance_squared_to(v2)
	
	var nX = abs(v1.x-v2.x)
	var lX = abs((X_SIZE+v1.x)-v2.x)
	var rX = abs((X_SIZE+v2.x)-v1.x)
	var x = min(nX, min(lX, rX))
	var y = v1.y-v2.y
	
	return (pow(x, 2) + pow(y, 2))

func ToStr():
	var s = ""
	
	for y in range(Y_SIZE):
		for x in range(X_SIZE):
			s += str(data[x][y]) + " "
		s += "\n"
	
	return s

func Load(f):
	for y in Y_SIZE:
		var line = f.get_line()
		var row = line.split(" ")
		for x in range(X_SIZE):
			var val = row[x]
			if val != ".":
				val = int(val)
			Set(x, y, val)

"""static func Load(f, x_size, y_size):
	var m = Map.new(x_size, y_size)
	
	for y in range(y_size):
		var line = f.get_line()
		var row = line.split(" ")
		for x in range(x_size):
			m.Set(x, y, 0)
	
	return m"""
