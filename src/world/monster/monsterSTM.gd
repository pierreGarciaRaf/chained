extends StateMachine



func _ready():
	add_state("getting_up_the_chain")
	add_state("idle")
	add_state("winding_jump")
	add_state("jump_on_player")
	add_state("get_to_torch")
	add_state('put_out_torch')
	set_state(states.idle)






func _get_transition(_delta):
	match state:
		states.idle:
			if parent.isChainTensed():
				return states.getting_up_the_chain
		states.getting_up_the_chain:
			if parent.canJumpOnPlayer():
				return states.winding_jump
			if parent.torchToPutOut:
				return states.get_to_torch
		states.winding_jump:
			if parent.torchToPutOut:
				return states.get_to_torch
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
		states.jump_on_player:
			if $Timer.time_left == 0:
				return states.getting_up_the_chain


func _enter_state(new_state,previous_state):
	if new_state != null and previous_state != null:
		if new_state != previous_state:
			print(states.keys()[previous_state], " --> ", states.keys()[new_state])
			match previous_state:
				states.jump_on_player:
					((get_node("../CollisionShape2D") as CollisionShape2D).shape as CircleShape2D).radius = 3
					(parent as KinematicBody2D).set_collision_mask_bit(0 , false)
			match new_state:
				states.idle:
					get_node("../run").stop()
				states.winding_jump:
					get_node("../bigGrowl").play(0.58)
					$Timer.start(0.5)
				states.put_out_torch:
					parent.put_out_torch()
					$Timer.start(1)
				states.jump_on_player:
					
					((get_node("../CollisionShape2D") as CollisionShape2D).shape as CircleShape2D).radius = 1
					(parent as KinematicBody2D).set_collision_mask_bit(0 , true)
					$Timer.start(1.0)
				states.getting_up_the_chain:
					get_node("../run").play()
					get_node("../mediumGrowl").play(0.0)
					


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
	var col = parent._applyVelocity(delta)
	if not state in [states.idle, states.get_to_torch, states.put_out_torch]:
		parent.tryToSeePlayer()
	if not state in [states.idle]:
		parent.checkForPlayerDeath(col)
