extends Node


var misc

var letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

var usStates = ["alabama", "alaska", "arizona", "arkansas", "california", "colorado", "connecticut", "delaware", "florida", "georgia", "idaho", "illinois", "indiana", "iowa", "kansas", "kentucky", "maine", "maryland", "massachusetts", "michigan", "minnesota", "mississippi", "missouri", "montana", "nebraska", "nevada", "hampshire", "jersey", "york", "carolina", "dakota", "ohio", "oklahoma", "oregon", "pennsylvania", "rhodes", "tennessee", "utah", "vermont", "virginia", "washington", "wisconsin", "wyoming"]
var usCounties = ["adair", "alfalfa", "atoka", "beaver", "beckham", "blaine", "bryan", "carter", "cleveland", "coal", "cotton", "craig", "custer", "dewey", "ellis", "garfield", "garvin", "grady", "grant", "greer", "harmon", "harper", "haskell", "hughes", "jackson", "jefferson", "johnston", "kingfisher", "latimer", "lincoln", "logan", "love", "major", "marshall", "mayes", "mcclain", "mccurtain", "mcintosh", "murray", "noble", "pawnee", "payne", "mills", "rogers", "tillman", "tulsa", "wagoner", "washington", "woods", "woodward", "allen", "anderson", "atchison", "barber", "barton", "bourbon", "brown", "butler", "chase", "clark", "clay", "cloud", "coffey", "cowley", "crawford", "decatur", "dickinson", "douglas", "edwards", "ellis", "ellsworth", "finney", "ford", "franklin", "geary", "grove", "graham", "grant", "gray", "greely", "greenwood", "hamilton", "harper", "harvey", "hodgeman", "jewell", "johnson", "kearney", "kingman", "lane", "leavenworth", "lincoln", "linn", "logan", "lyon", "marion", "marshall", "mcpherson", "meade", "mitchell", "montgomery", "morris", "morton", "ness", "norton", "osborne", "phillips", "pratt", "rawlins", "reno", "rice", "riley", "rooks", "rush", "russell", "salina", "scott", "sedgewick", "seward", "sheridan", "sherman", "smith", "stafford", "stanton", "stevens", "sumner", "thomas", "wallace", "washington", "wilson", "woodson", "anderson", "andrews", "aransas", "archer", "armstrong", "austin", "bailey", "bastrop", "baylor", "bee", "bell", "borden", "bowie", "brewster", "briscoe", "brooks", "brown", "burleson", "burnet", "caldwell", "calhoun", "callahan", "cameron", "camp", "carson", "cass", "chambers", "childress", "clay", "cochran", "coke", "coleman", "collin", "collingsworth", "cooke", "coryell", "cottle", "crane", "crockett", "crosby", "culberson", "dallam", "dallas", "dawson", "delta", "denton", "dewitt", "dickens", "dimmit", "donley", "duval", "eastland", "ector", "edwards", "ellis", "erath", "falls", "fannin", "fisher", "floyd", "foard", "franklin", "freestone", "gaines", "galveston", "gillespie", "glasscock", "goliad", "gray", "grayson", "gregg", "grimes", "hale", "hall", "hamilton", "hansford", "hardeman", "hardin", "harris", "harrison", "hartley", "haskell", "hays", "hemphill", "henderson", "hill", "hockley", "hood", "hopkins", "houston", "howard", "howard", "hudspeth", "hunt", "hutchinson", "irion", "jack", "jackson", "jasper", "jefferson", "johnson", "jones", "karnes", "kaufman", "kendall", "kenedy", "kent", "kerr", "kimble", "king", "kinney", "kleberg", "knox", "lamar", "lamb", "lee", "leon", "liberty", "limestone", "lipscomb", "loving", "lubbock", "lynn", "mccullough", "mclennan", "mcmullen", "madison", "marion", "martin", "mason", "maverick", "medina", "menard", "midland", "milam", "mills", "mitchell", "montague", "montgomery", "moore", "morris", "motley", "newton", "nolan", "oldham", "orange", "parker", "parmer", "polk", "potter", "rains", "randall", "reagan", "real", "reeves", "roberts", "robertson", "rockwall", "runnels", "rusk", "sabine", "schleicher", "scurry", "shackleford", "shelby", "sherman", "smith", "somervell", "starr", "stephens", "sterling", "stonewall", "sutton", "swisher", "tarrant", "taylor", "terrell", "terry", "throckmorton", "titus", "travis", "trinity", "tyler", "upshur", "upton", "victoria", "walker", "waller", "ward", "washington", "webb", "wharton", "wheeler", "wilbarger", "willacy", "williamson", "wilson", "winkler", "wise", "wood", "young"] #includes OK, KS, TX
var usCities = ["chicago", "houston", "philadelphia", "phoenix", "dallas", "austin", "jacksonville", "indianapolis", "columbus", "worth", "charlotte", "seattle", "denver", "detroit", "washington", "boston", "memphis", "nashville", "portland", "louisville", "baltimore", "milwaukee", "tuscon", "fresno", "sacramento", "atlanta", "long", "beach", "springs", "raleigh", "miami", "omaha", "oakland", "tulsa", "arlington", "wichita", "cleveland", "tampa", "bakersfield", "aurora", "anaheim", "riverside", "lexington", "stockton", "pittsburgh", "paul", "cincinnati", "anchorage", "henderson", "greensboro", "plano", "newark", "lincoln", "toledo", "orlando", "irvine", "wayne", "durham", "petersburg", "laredo", "buffalo", "madison", "lubbock", "chandler", "scottsdale", "glendale", "reno", "norfolk", "winston", "salem", "irving", "chesapeake", "gilbert", "garland", "fremont", "boise", "spokane", "birmingham", "tacoma", "fontana", "rochester", "oxnard", "fayetteville", "aurora", "yonkers", "huntington", "montgomery", "little", "rock", "akron", "augusta", "grand", "rapids", "shreveport", "huntsville", "mobile", "overland", "park", "worcester", "brownsville", "newport", "cape", "coral", "providence", "lauderdale", "chattanooga", "oceanside", "garden", "grove", "vancouver", "ontario", "mckinney", "grove", "jackson", "pembroke", "pines", "springfield", "eugene", "collins", "peoria", "frisco", "cary", "lancaster", "hayward", "palmdale", "alexandria", "lakewood", "sunnyvale", "macon", "pomona", "hollywood", "clarksville", "joliet", "rockford", "torrance", "naperville", "paterson", "savannah", "bridgeport", "mesquite", "killeen", "syracuse", "mcallen", "bellevue", "fullerton", "orange", "dayton", "miramar", "thornton", "valley", "olathe", "hampton", "warren", "midland", "waco", "charleston", "denton", "columbia", "carrollton", "surprise", "roseville", "sterling", "heights", "gainesville", "cedar", "visalia", "coral", "haven", "stamford", "thousand", "concord", "elizabeth", "lafayette", "kent", "topeka", "athens", "hartford", "victor", "abilene", "norman", "berkeley", "round", "annarbor", "fargo", "allentown", "evansville", "beaumont", "odessa", "wilmington", "arvada", "independence", "provo", "lansing", "springfield", "fairfield", "clearwater", "rochester", "carlsbad", "pearland", "jordan", "richardson", "downey", "college", "station", "elgin", "gresham", "inglewood", "cambridge", "lowell", "bilings", "palm", "centennial", "richmond", "everett", "boulder", "arrow", "clovis", "lakeland", "norwalk", "hillsboro", "green", "tyler", "falls", "lewisville", "burbank", "greeley", "davenport", "league", "edison", "davie", "woodbridge", "renton", "lakewood", "clinton"]

var canCities = ["toronto", "montreal", "calgary", "ottawa", "edmonton", "winnipeg", "vancouver", "brampton", "hamilton", "quebec", "surrey", "laval", "halifax", "london", "markham", "vaughan", "gatineau", "saskatoon", "kitchener", "burnaby", "windsor", "regina", "richmond", "burlington", "sudbury", "sherbrooke", "oshawa", "saguenay", "levis", "barrie", "abbotsford", "coquitlam", "catharines", "guelph", "cambridge", "whitby", "kelowna", "kingston", "ajax", "langley", "milton", "johns", "thunder", "waterloo", "delta", "chatham", "kent", "strathcona", "brantford", "breton", "lethbridge", "clarington", "pickering", "niagra", "victoria", "brossard", "newmarket", "maple", "ridge", "peter", "drummond", "prince", "george", "sault", "moncton", "sarnia", "caledon", "granby", "albert", "norfolk", "grande", "prarie", "airdrie", "halton", "blaine", "hyacinthe", "aurora", "welland", "belle", "mirabel"]

var usMaleFirsts = ["liam", "noah", "william", "james", "logan", "benjamin", "mason", "elijah", "oliver", "jacob", "lucas", "michael", "alexander", "ethan", "daniel", "matthew", "aiden", "henry", "joseph", "jackson", "samuel", "sebastian", "david", "carter", "wyatt", "jayden", "john", "owen", "dylan", "luke", "gabriel", "anthony", "isaac", "grayson", "jack", "julian", "levi", "christopher", "joshua", "andrew", "lincoln", "mateo", "ryan", "jaxon", "nathan", "aaron", "isaiah", "thomas", "charles", "caleb", "josiah", "christian", "hunter", "eli", "jonathan", "connor", "landon", "adrian", "asher", "cameron", "leo", "theodore", "jeremiah", "hudson", "robert", "easton", "nolan", "nicholas", "ezra", "colton", "brayden", "jordan", "dominic", "austin", "ian", "adam", "elias", "jaxson", "greyson", "ezekiel", "carson", "evan", "maverick", "bryson", "jace", "cooper", "xavier", "parker", "roman", "jason", "chase", "sawyer", "gavin", "kayden", "ayden", "jameson", "kevin", "bentley", "zachary", "everett", "axel", "tyler", "micah", "vincent", "weston", "miles", "wesley", "nathaniel", "nathan", "harrison", "brandon", "cole", "declan", "braxton", "damian", "silas", "tristan", "ryder", "bennett", "george", "emmett", "justin", "kai", "max", "ryker", "maxwell", "kingston", "ivan", "maddox", "ashton", "jayce", "rowan", "kaiden", "eric", "calvin", "abel", "king", "camden", "blake", "alex", "brody", "malachi", "jonah", "beau", "jude", "alan", "elliot", "waylon", "xander", "timothy", "victor", "bryce", "finn", "brantley", "edward", "abraham", "patrick", "grant", "karter", "hayden", "richard", "joel", "gael", "tucker", "rhett", "avery", "steven", "graham", "kaleb", "jasper", "jesse", "matteo", "dean", "zayden", "preston", "august", "oscar", "jeremey", "marcus", "dawson", "zion", "maximus", "river", "zane", "mark", "brooks", "nicolas", "paxton", "judah", "kaden", "bryan", "kyle", "myles", "peter", "charlie", "kyrie", "brian", "kenneth", "lukas", "aidan", "jax", "caden", "milo", "paul", "beckett", "brady", "colin", "bradley", "knox", "jaden", "barrett", "israel", "matias", "zander", "derek", "cayden", "holden", "griffin", "arthur", "leon", "felix", "remington", "jake", "killian", "clayton"] # https://www.ssa.gov/cgi-bin/popularnames.cgi 2017
var usFemaleFirsts = ["emma", "olivia", "ava", "isabella", "sophia", "mia", "charlotte", "amelia", "evelyn", "abigail", "harper", "emily", "elizabeth", "avery", "sofia", "ella", "madison", "scarlett", "victoria", "aria", "grace", "chloe", "camila", "penelope", "riley", "layla", "lillian", "nora", "zoey", "mila", "aubrey", "hannah", "lily", "addison", "eleanor", "natalie", "luna", "savannah", "brooklyn", "leah", "zoe", "stella", "hazel", "ellie", "paisley", "audrey", "skylar", "violet", "claire", "bella", "aurora", "lucy", "anna", "samantha", "caroline", "genesis", "aaliyah", "kennedy", "kinsley", "allison", "maya", "sarah", "madelyn", "adeline", "alexa", "ariana", "elena", "gabriella", "naomi", "alice", "sadie", "hailey", "eva", "emilia", "autumn", "quinn", "nevaeh", "piper", "ruby", "serenity", "willow", "everly", "cora", "kaylee", "lydia", "aubree", "arianna", "eliana", "peyton", "melanie", "gianna", "isabelle", "julia", "valentina", "nova", "clara", "vivian", "reagan", "mackenzie", "madeline", "brielle", "delilah", "isla", "rylee", "katherine", "sophie", "josephine", "ivy", "liliana", "jade", "maria", "taylor", "hadley", "kylie", "emery", "adalynn", "natalia", "annabelle", "faith", "alexandra", "ximena", "ashley", "brianna", "raelynn", "bailey", "mary", "athena", "andrea", "leilani", "jasmine", "lyla", "margaret", "alyssa", "adalyn", "arya", "norah", "khloe", "kayla", "eden", "eliza", "rose", "ariel", "melody", "alexis", "isabel", "sydney", "juliana", "lauren", "iris", "emerson", "london", "morgan", "lilly", "charlie", "aliyah", "valeria", "arabella", "sara", "finley", "trinity", "ryleigh", "jordyn", "jocelyn", "kimberly", "esther", "molly", "valerie", "cecilia", "anastasia", "daisy", "reese", "laila", "mya", "amy", "teagan", "amaya", "elise", "harmony", "paige", "adaline", "fiona", "alaina", "nicole", "genevieve", "lucia", "alina", "mckenzie", "callie", "payton", "eloise", "brooke", "londyn", "mariah", "julianna", "rachel", "daniela", "gracie", "catherine", "angelina", "presley", "josie", "harley", "adelyn", "vanessa", "makayla", "parker", "juliette", "amara", "marley", "lila", "ana", "alana", "michelle", "malia", "rebecca", "brooklynn", "brynlee", "summer", "sloane", "leila", "sienna", "adriana", "kendall"]

var probMatrix = {}
var minLen = 4
var maxLen = 99

func _ready():
	randomize()
	misc = get_parent().get_parent().get_parent().get_node("Miscellaneous")

func InitializeProbMatrix():
	for l in letters:
		probMatrix[l] = {}
		for m in letters:
			probMatrix[l][m] = 0

func SetProbMatrix1(input):
	for word in input:
		var curr = 0
		probMatrix["st"][word[curr]] += 1
		while curr+1 < len(word):
			probMatrix[word[curr]][word[curr+1]] += 1
			curr += 1
		probMatrix[word[curr]]["fin"] += 1

func SetProbMatrix2(input):
	probMatrix["_"] = {}
	for word in input:
		word += "--"

		#store start
		if word[0] + word[1] in probMatrix["_"]:
			probMatrix["_"][word[0] + word[1]] += 1
		else:
			probMatrix["_"][word[0] + word[1]] = 1

		#store start + [0]
		if !("_" + word[0] in probMatrix):
			probMatrix["_" + word[0]] = {}
		if word[1] + word[2] in probMatrix["_" + word[0]]:
			probMatrix["_" + word[0]][word[1] + word[2]] += 1
		else:
			probMatrix["_" + word[0]][word[1] + word[2]] = 1

		#rest of word
		var i = 0
		while i+3 < len(word):
			if !(word[i] + word[i+1] in probMatrix):
				probMatrix[word[i] + word[i+1]] = {}
			if word[i+2] + word[i+3] in probMatrix[word[i] + word[i+1]]:
				probMatrix[word[i] + word[i+1]][word[i+2] + word[i+3]] += 1
			else:
				probMatrix[word[i] + word[i+1]][word[i+2] + word[i+3]] = 1
			i += 1

func Generate1():
	var result = ""

	var next = misc.WeightedRandomChoice(probMatrix["st"])
	var last
	while next != "fin" or len(result) < 4:
		if next == "fin":
			next = misc.WeightedRandomChoice(probMatrix[last])
		else:
			result += next
			last = next
			next = misc.WeightedRandomChoice(probMatrix[last])

	return result

func Generate2():
	var result = "_"

	var next = misc.WeightedRandomChoice(probMatrix["_"])
	var j = 0
	while !("-" in next) or result.length() < 4:
		if "-" in next:
			next = misc.WeightedRandomChoice(probMatrix[result[j-1] + result[j]])
		else:
			j += 2
			#print(next)
			result += next
			#print(result)
			next = misc.WeightedRandomChoice(probMatrix[result[j-1] + result[j]])

	result += next.replace("-", "")

	return result.right(1).capitalize()

func Generate(blacklist=[]):
	var result = Generate2()
	while len(result) > maxLen or len(result) < minLen or result in blacklist:
		result = Generate2()
	return result