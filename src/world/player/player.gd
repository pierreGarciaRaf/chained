extends KinematicBody2D

export var speed = 100

func _physics_process(delta):
	var xAxis = int(Input.is_action_pressed("go_right")) - int(Input.is_action_pressed("go_left"))
	var yAxis = int(Input.is_action_pressed("go_down")) - int(Input.is_action_pressed("go_up"))
	
	self.move_and_slide(Vector2(xAxis,yAxis).normalized() * speed)

