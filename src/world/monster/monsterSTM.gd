extends StateMachine



func _ready():
	add_state("getting_up_the_chain")
	add_state("idle")
	
	set_state(states.idle)


func _enter_state(new_state,previous_state):
	if new_state != previous_state and previous_state != null:
		print(previous_state," -> ", new_state)

func _get_transition(_delta):

	if Input.is_action_pressed("ui_accept"):
		print("ui accept")
		return states.getting_up_the_chain
	elif Input.is_action_pressed("ui_cancel"):
		return states.idle


func _state_logic(delta):
	match state:
		states.idle:
			parent.idle()
		states.getting_up_the_chain:
			parent.get_up_the_chain()
	parent._applyVelocity()
