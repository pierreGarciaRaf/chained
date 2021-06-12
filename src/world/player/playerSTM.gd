extends StateMachine

func _ready():
	add_state("walkNorthSide")
	add_state("walkSouthSide")
	add_state("idle")
	call_deferred("set_state",states.idle)



func _enter_state(new_state,previous_state):
	if new_state != previous_state and previous_state != null:
		print(previous_state," -> ", new_state)

func _get_transition(_delta):
	pass



func _state_logic(delta):
	pass

