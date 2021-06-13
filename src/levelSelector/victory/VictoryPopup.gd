extends Popup

signal animation_ended

func _on_AnimatedSprite_animation_finished():
	print('animation completed')
	emit_signal("animation_ended")


func _on_VictoryPopup_about_to_show():
	$Control/AnimatedSprite.frame=0
	$Control/AnimatedSprite.speed_scale=0.1
	$Control/AnimatedSprite.play('default')
