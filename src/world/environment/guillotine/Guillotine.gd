extends Node2D

signal guillotine_entered(body)


func _on_Area2D_body_entered(body):	
	emit_signal("guillotine_entered",body)
