extends AudioStreamPlayer

export(float) var min_delay=1
export(float) var max_delay=5

func _ready():
	play_next()

func play_next():
	var sound_start = rand_range(min_delay, max_delay)
	$Timer.start(sound_start)



func _on_Timer_timeout():
	print('playing ',self.name)
	self.play()


func _on_RandomSound_finished():
	 play_next()
