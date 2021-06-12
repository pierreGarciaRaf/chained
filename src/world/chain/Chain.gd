extends Node2D
class_name Chain

var Loop = preload("res://src/world/chain/Loop.tscn")
var Joint = preload("res://src/world/chain/Joint.tscn")

const points_density = 0.08 # number of items per pixel ? unit offset

# initial path
var points:PoolVector2Array

# chain links
var player:KinematicBody2D
var monster:KinematicBody2D

func _ready():
	self.position = points[0]
	build_chain()

func _process(_delta):
	# update Line2D with position of rigidbodies
	for i in range(0, $Chain.get_child_count()):
		$Line2D.set_point_position(i, $Chain.get_child(i).position)


func build_chain():
	print("build")
	# Build
	var length = build_curve()
	$Path2D/PathFollow2D.unit_offset = 0
	var head_position = $Path2D/PathFollow2D.position
	
	var count = max(1,round(points_density * length))
	var unit_offset_step = 1.0/count
	var parent = monster
	for _loop_index in range (1+count):
		var new_position = $Path2D/PathFollow2D.position - head_position
		var child = addLoop(new_position)
		addLink(parent, child)
		parent = child
		$Line2D.add_point(new_position)
		$Path2D/PathFollow2D.unit_offset += unit_offset_step
	addLink(parent,player)

func addLoop(position):
	var loop = Loop.instance()
	loop.position = position
	$Chain.add_child(loop)
	return loop

func addLink(parent, child):
	if parent == null:
		return
	var pin = Joint.instance()
	pin.node_a = parent.get_path()
	pin.node_b = child.get_path()
	parent.add_child(pin)


func build_curve():
	var curve2D = Curve2D.new()
	var length=0
	var prev_point=null
	for point in points:
		curve2D.add_point(point)
		if prev_point:
			length+= point.distance_to(prev_point)
		prev_point=point
	$Path2D.curve = curve2D
	return length

