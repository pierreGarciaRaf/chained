extends Node

var maxUnlockedLevel = 0
var actualLevel = 0

func unlockNextLevel():
	if maxUnlockedLevel == actualLevel:
		maxUnlockedLevel +=1

func unlockedLevelNumber(levelNumber):
	return levelNumber <= maxUnlockedLevel

func changeToLevel(levelNumber):
	if unlockedLevelNumber(levelNumber):
		get_tree().change_scene_to(load(get_level_path(levelNumber)))
		actualLevel = levelNumber

func restartLevel():
	changeToLevel(actualLevel)

func changeToNextLevel():
	changeToLevel(actualLevel + 1)

func get_level_path(levelNumber):
	return "res://src/levels/orderedLevels/level" + String(levelNumber) + ".tscn"


