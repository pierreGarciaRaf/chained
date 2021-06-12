extends KinematicBody2D

export var speed = 100
var velocity:Vector2 = Vector2.ZERO 
func _physics_process(delta):
	var xAxis = int(Input.is_action_pressed("go_right")) - int(Input.is_action_pressed("go_left"))
	var yAxis = int(Input.is_action_pressed("go_down")) - int(Input.is_action_pressed("go_up"))
	
	velocity = self.move_and_slide(Vector2(xAxis,yAxis).normalized() * speed)

