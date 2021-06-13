extends Node2D
signal monsterSeen

var monster: Node2D
var player:Node2D = null

export var lit = true setget setLit

func _ready():
	setLit(lit)

func _process(delta):
	if lit:
		if $RayCast2D.enabled:
			$RayCast2D.cast_to = monster.position -self.position
			if $RayCast2D.is_colliding():
				if isMonster($RayCast2D.get_collider()):
					$RayCast2D.get_collider()._onSeeingTorch(self)
	else:
		if player:
			if Input.is_action_pressed("lit"):
				setLit(true)

func isMonster(body):
	print(body.name)
	return body.name == "monster"


func _on_monsterDetector_body_entered(body):
	if isMonster(body):
		monster = body
		$RayCast2D.cast_to = body.position - self.position
		$RayCast2D.enabled = true



func _on_monsterDetector_body_exited(body):
	if isMonster(body):
		$RayCast2D.enabled = false

func put_out():
	setLit(false)

func isPlayer(body):
	if body:
		return body.name == "player"
	return false

func setLit(value):
	if value:
		$AnimationPlayer.play("light")
		($monsterDetector/CollisionShape2D as CollisionShape2D).disabled = false
		$playerDetector/CollisionShape2D.disabled = true
	else:
		$AnimationPlayer.play("putOut")
		$RayCast2D.enabled = false
		$monsterDetector/CollisionShape2D.disabled = true
		$playerDetector/CollisionShape2D.disabled = false
	lit = value

func _on_playerDetector_body_entered(body):
	if isPlayer(body):
		player = body

func _on_playerDetector_body_exited(body):
	if isPlayer(body):
		player = null


