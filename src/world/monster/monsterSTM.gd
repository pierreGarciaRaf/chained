extends StateMachine



func _ready():
	add_state("getting_up_the_chain")
	add_state("idle")
	
	set_state(states.idle)


func _enter_state(new_state,previous_state):
	if new_state != previous_state and previous_state != null:
		print(previous_state," -> ", new_state)
		match new_state:
			states.getting_up_the_chain:
				parent.timeIChangedLink = 2
				parent.target_pos = parent.position


func _get_transition(_delta):
	match state:
		states.idle:
			if parent.isChainTensed():
				return states.getting_up_the_chain
		states.getting_up_the_chain:
			if Input.is_action_just_pressed("ui_cancel") or parent.isChainFinished():
				return states.idle


func _state_logic(delta):
	match state:
		states.idle:
			parent.idle()
		states.getting_up_the_chain:
			parent.get_up_the_chain()
	parent._applyVelocity()
