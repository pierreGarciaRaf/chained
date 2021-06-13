extends StateMachine

onready var otherSTM : StateMachine = get_node("../MonsterSTM") 

onready var animatedSprite : AnimatedSprite = get_node("../AnimatedSprite")

func _ready():
	add_state("walkNorthSide")
	add_state("walkSouthSide")
	add_state("runNorthSide")
	add_state("runSouthSide")
	add_state("idle")
	add_state("crouch")
	add_state("jump")
	call_deferred("set_state",states.idle)



func _enter_state(new_state,previous_state):
	if new_state != previous_state and previous_state != null:
#		print(states.keys()[previous_state]," -> ", states.keys()[new_state])
		if previous_state==states.idle:
			animatedSprite.self_modulate = Color("ffffff")
		match new_state:
			states.idle:
				animatedSprite.stop()
				animatedSprite.frame = 0
				animatedSprite.self_modulate = Color("2eb7f2")
			states.walkNorthSide:
				animatedSprite.play("walkingBack")
			states.walkSouthSide:
				animatedSprite.play("walkingFront")
			states.runNorthSide:
				animatedSprite.play("runningBack")
			states.runSouthSide:
				animatedSprite.play("runningFront")
			states.crouch:
				animatedSprite.play("crouch")
			states.jump:
				animatedSprite.play("jump")
				animatedSprite.frame = 0


func _get_transition(_delta):
	match otherSTM.state:
		otherSTM.states.winding_jump:
			return states.crouch
		otherSTM.states.jump_on_player:
			return states.jump
		
	if parent.velocity.length() == 0:
		return states.idle
	else:
		var velDotUp = parent.velocity.dot(Vector2.UP)/parent.speed
		if velDotUp > .5:
			return states.walkNorthSide
		elif velDotUp > 0 or velDotUp <= .5:
			return states.walkNorthSide
		elif velDotUp < -parent.speed/2:
			return states.walkSouthSide




func _state_logic(delta):
	pass

