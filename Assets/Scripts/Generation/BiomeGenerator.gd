class_name BiomeGenerator

var RNG = RandomNumberGenerator.new()

var soils = ["Marsh", "Clay", "Loam", "Dirt", "Sand", "Stone"]
var soilColors = {
	"Marsh": Color(0.2, 0.1, 0.1, 1),
	"White Clay": Color("cccccc"),
	"Red Clay": Color("994339"),
	"Brown Clay": Color("5a2117"),
	"Loam": Color("68493c"),
	"Dirt": Color("a6674d"),
	"Sand": Color("e5cf98"),
	"Bluestone": Color("a7bfe2"),
	"Brownstone": Color("8c6b62"),
	"Granite": Color("757580"),
	"Lavendrite": Color("bdb1cc"),
	"Limestone": Color("b6c0b2"),
	"Redrock": Color("cc998f"),
	"Sandstone": Color("ccb887"),
	"Verdrum": Color("a3ccb2"),
	"Whitestone": Color("e5e5e5")
}

func _ready():
	pass

func Generate(b):
	b.soil = soils[RNG.randi_range(5-b.planet.moisture, clamp(5-b.planet.moisture+3, 0, 5))]
	if b.soil == "Clay":
		b.soil = ["White Clay", "Red Clay", "Brown Clay"][randi()%3]
	elif b.soil == "Stone":
		b.soil = b.planet.bedrock
	
	b.sColor = soilColors[b.soil]
	
	if not b.planet.atmosphere:
		return
	
	b.gcColor = ColorN(["lightgreen", "green", "darkgreen", "lightseagreen", "darkolivegreen", "lawngreen", "forestgreen"][randi()%7])
	b.lfColor = b.gcColor.darkened(0.1)
