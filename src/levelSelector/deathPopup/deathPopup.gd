extends PopupPanel






func _on_getToMenu_pressed():
	print("get_to_menu")
	print(get_tree().change_scene_to(load("res://src/levelSelector/levelSelector.tscn")))
	get_tree().paused = false



func _on_getToNextLevel_pressed():
	LevelChangeManager.restartLevel()
	get_tree().paused = false



