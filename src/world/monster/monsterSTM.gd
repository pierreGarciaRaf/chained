extends StateMachine



func _ready():
	add_state("getting_up_the_chain")
	add_state("idle")
	add_state("winding_jump")
	add_state("jump_on_player")
	add_state("get_to_torch")
	add_state('put_out_torch')
	set_state(states.idle)


func _enter_state(new_state,previous_state):
	if new_state != null and previous_state != null:
		if new_state != previous_state:
			print(states.keys()[previous_state], " --> ", states.keys()[new_state])
			match new_state:
				states.winding_jump:
					$Timer.start(0.5)
				states.put_out_torch:
					parent.put_out_torch()
					$Timer.start(1)



func _get_transition(_delta):
	match state:
		states.idle:
			if parent.isChainTensed():
				return states.getting_up_the_chain
		states.getting_up_the_chain:
			if Input.is_action_just_pressed("ui_cancel"):
				return states.idle
			if parent.canJumpOnPlayer():
				return states.winding_jump
			if parent.torchToPutOut:
				return states.get_to_torch
		states.winding_jump:
			if $Timer.time_left == 0 :
				if parent.canJumpOnPlayer():
					return states.jump_on_player
				else:
					return states.getting_up_the_chain
		states.get_to_torch:
			if parent.close_enough_to_torch():
				return states.put_out_torch
		states.put_out_torch:
			if $Timer.time_left == 0:
				return states.idle



func _state_logic(delta):
	match state:
		states.idle:
			parent.idle()
		states.getting_up_the_chain:
			parent.get_to_player()
		states.winding_jump:
			parent.idle()
		states.jump_on_player:
			parent.jump_on_player()
		states.get_to_torch:
			parent.get_to_torch()
		states.put_out_torch:
			parent.idle()
	parent._applyVelocity(delta)
	if not state in [states.idle, states.get_to_torch, states.put_out_torch]:
		parent.tryToSeePlayer()
