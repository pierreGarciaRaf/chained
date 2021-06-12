extends Control



func _ready():
	$SoundTimer.start()


func _on_SoundTimer_timeout():
	$Introduction.play()


func _on_Introduction_finished():
	$SoundTimer.wait_time=5
	$SoundTimer.start()
