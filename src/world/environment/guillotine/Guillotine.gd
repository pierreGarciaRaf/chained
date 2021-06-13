extends Node2D

signal guillotine_entered(body)
signal safe_place_entered(body)

func _on_Guillotine_entered(body):
	emit_signal("guillotine_entered",body)


func _on_SafePlace_body_entered(body):
	emit_signal("safe_place_entered",body)
