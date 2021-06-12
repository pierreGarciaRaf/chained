extends StateMachine



func _ready():
	add_state("getting_up_the_chain")
	add_state("idle")
	add_state("winding_jump")
	add_state("jump_on_player")
	set_state(states.idle)


func _enter_state(new_state,previous_state):
	if new_state != null and previous_state != null:
	
	
		if new_state != previous_state:
			print(states.keys()[previous_state], " --> ", states.keys()[new_state])
			match new_state:
				states.winding_jump:
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
		states.winding_jump:
			if $Timer.time_left == 0 :
				if parent.canJumpOnPlayer():
					return states.jump_on_player
				else:
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
	parent._applyVelocity(delta)
