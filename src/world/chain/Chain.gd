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

signal chain_is_tensed(direction,player_direction)

var initial_length = 5000000
var tenseRatio = 1.5

func _ready():
	self.position = points[0]
	build_chain()

func _process(_delta):
	# update Line2D with position of rigidbodies
	for i in range(0, $Chain.get_child_count()):
		$Line2D.set_point_position(i, $Chain.get_child(i).position)
	if is_chain_tensed():
#		print('ça tire', initial_length,' ',lengthOf($Line2D.points))
		var chain_direction = $Chain.get_child(0).position.direction_to($Chain.get_child(1).position)	
		var player_direction = monster.position.direction_to(player.position)
		emit_signal("chain_is_tensed",chain_direction,player_direction)

func is_chain_tensed():
	return lengthOf($Line2D.points)/initial_length > tenseRatio

func build_chain():
	print("build")
	# Build
	var length = build_curve()
	$Path2D/PathFollow2D.unit_offset = 0
	var head_position = $Path2D/PathFollow2D.position
	
	var count = max(1,round(points_density * length))
	var unit_offset_step = 1.0/count
	var parent = monster
	for _loop_index in range (count):
		var new_position = $Path2D/PathFollow2D.position - head_position
		var child = addLoop(new_position)
		addLink(parent, child)
		parent = child
		$Line2D.add_point(new_position)
		$Path2D/PathFollow2D.unit_offset += unit_offset_step
	addLink(parent,player)
	initial_length=lengthOf($Line2D.points)

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

func lengthOf(points : PoolVector2Array):
	var length=0
	var prev_point=null
	for point in points:
		if prev_point:
			length+= point.distance_to(prev_point)
		prev_point=point
	return length

func get_loop(loopIndex):
	return $Chain.get_child(loopIndex)

func get_loop_normal(loopIndex):
	if loopIndex > 1:
		var nextLoopDir = $Chain.get_child(loopIndex).global_position - $Chain.get_child(loopIndex-1).global_position
		return (nextLoopDir as Vector2).tangent().normalized()
	else:
		return Vector2.ZERO


func has_loop(loopIndex):
	return $Chain.get_child_count() > loopIndex and loopIndex >= 0
