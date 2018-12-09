extends Node

var engLoc
var engFirstM
var engFirstF
var engLast

func _ready():
	#$LocationNamers/USLocationNamer.SetProbMatrix2($LocationNamers/USLocationNamer.usStates + $LocationNamers/USLocationNamer.usCounties)
	#$CharacterNamers/EnglishLastNamer.SetProbMatrix2(
	
	engLoc = $LocationNamers/EnglishLocationNamer
	engFirstM = $CharacterNamers/EnglishFirstNamerM
	engFirstF = $CharacterNamers/EnglishFirstNamerF
	engLast = $CharacterNamers/EnglishLastNamer
	
	engLoc.SetProbMatrix2(engLoc.usStates + engLoc.usCounties)
	engFirstM.SetProbMatrix2(engFirstM.usMaleFirsts)
	engFirstF.SetProbMatrix2(engFirstF.usFemaleFirsts)
	engLast.SetProbMatrix2(engLast.usCounties)
	
	engFirstM.maxLen = 8
	engFirstF.maxLen = 10
	engLast.maxLen = 10