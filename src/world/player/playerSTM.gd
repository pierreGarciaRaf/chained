extends StateMachine

onready var animatedSprite : AnimatedSprite = get_node("../AnimatedSprite")

func _ready():
	add_state("walkNorthSide")
	add_state("walkSouthSide")
	add_state("walkEastSide")
	add_state("walkWestSide")
	add_state("idle")
	call_deferred("set_state",states.idle)



func _enter_state(new_state,previous_state):
	if new_state != previous_state and previous_state != null:
#		print(states.keys()[previous_state]," -> ", states.keys()[new_state])
		match new_state:
			states.idle:
				animatedSprite.stop()
				animatedSprite.frame = 0
			states.walkNorthSide:
				animatedSprite.play("walkingUp")
			states.walkSouthSide:
				animatedSprite.play("walkingDown")
			states.walkEastSide:
				animatedSprite.play("walkingRight")
			states.walkWestSide:
				animatedSprite.play("walkingLeft")

func _get_transition(_delta):
	if parent.velocity.length() == 0:
		return states.idle
	else:
		if state in [states.walkNorthSide, states.walkSouthSide, states.idle] or parent.velocity.dot(Vector2.LEFT) == 0:
			if parent.velocity.dot(Vector2.UP) > 0:
				return states.walkNorthSide
			elif parent.velocity.dot(Vector2.UP) < 0:
				return states.walkSouthSide
		if state in [states.walkEastSide, states.walkWestSide, states.idle] or parent.velocity.dot(Vector2.UP) == 0:
			if parent.velocity.dot(Vector2.RIGHT) > 0:
				return states.walkEastSide
			elif parent.velocity.dot(Vector2.RIGHT) < 0:
				return states.walkWestSide



func _state_logic(delta):
	pass

