extends Node2D
signal monsterSeen

var monster: Node2D



func isMonster(body):
	return body.name == "monster"


func _on_monsterDetector_body_entered(body):
	if isMonster(body):
		monster = body
		$RayCast2D.cast_to = body.position - self.position
		$RayCast2D.enabled = true

func _process(delta):
	if $RayCast2D.enabled:
		$RayCast2D.cast_to = monster.position -self.position
		if $RayCast2D.is_colliding():
			if isMonster($RayCast2D.get_collider()):
				$RayCast2D.get_collider()._onSeeingTorch(self)

func _on_monsterDetector_body_exited(body):
	if isMonster(body):
		$RayCast2D.enabled = false

func kill():
	$AnimationPlayer.play("putOut")
	$monsterDetector.disconnect("body_entered",self,"_on_monsterDetector_body_entered")
	$monsterDetector.disconnect("body_exited",self,"_on_monsterDetector_body_exited")
	$RayCast2D.enabled = false
	
	
