extends Node2D

signal guillotine_entered(body)
signal safe_place_entered(body)

var fallen=false
func _ready():
	pass
	
func _on_Guillotine_entered(body):
	emit_signal("guillotine_entered",body)


func _on_SafePlace_body_entered(body):
	emit_signal("safe_place_entered",body)

func fall():
	if fallen:
		return
	print('guillotine fall')
	$BladeAnimation.play("fall_blade",-1,3)


func _on_BladeAnimation_animation_finished(anim_name):
	fallen=true
