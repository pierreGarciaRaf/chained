extends KinematicBody2D

var velocity = Vector2.ZERO
var chain :Node2D
export var chainPath : NodePath
var target_link:Node2D
var requiredDistance = 50.0

var timeIChangedLink = 0 #for debug

export var speed = 110

func _applyVelocity():
	velocity = self.move_and_slide(velocity)

func get_up_the_chain():
	if has_to_change_target_link():
		timeIChangedLink += 1
		print(timeIChangedLink)
		target_link = next_link()
	var directionToGoTo = (target_link.position - self.position).normalized()
	velocity = directionToGoTo * speed

func has_to_change_target_link():
	if target_link == null:
		return true
	return (target_link.position - self.position).length() < requiredDistance

func next_link():
	return get_node(chainPath)

func idle():
	velocity = 0
