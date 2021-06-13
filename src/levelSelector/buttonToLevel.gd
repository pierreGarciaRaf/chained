extends Button

var levelNumber
func get_level_number():
	return int((self.name as String).trim_prefix("buttonToLevel"))

func _ready(): 
	levelNumber = get_level_number()
	self.disabled = not LevelChangeManager.unlockedLevelNumber(levelNumber)
	self.text = "Level " + String(levelNumber)



func _on_buttonToLevel_pressed():
	LevelChangeManager.changeToLevel(levelNumber)
