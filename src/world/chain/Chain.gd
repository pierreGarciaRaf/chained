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

var LighRes = preload("res://src/world/environment/torch/generalLight.tscn")


func _ready():
	self.position = points[0]
	build_chain()

func _process(_delta):
	# update Line2D with position of rigidbodies
	for i in range(0, $Chain.get_child_count()):
		$Line2D.set_point_position(i, $Chain.get_child(i).position)
	if is_chain_tensed():
		print('ça tire', initial_length,' ',lengthOf($Line2D.points))
		var chain_direction = $Chain.get_child(0).position.direction_to($Chain.get_child(1).position)	
		var player_direction = monster.position.direction_to(player.position)
		emit_signal("chain_is_tensed",chain_direction,player_direction)
		move_monster_up_swap()

func get_joint(node : Node2D):
	for child in node.get_children():
		if child is Joint2D:
			return child
	return null

func move_monster_up():
	var monster_joint: Joint2D = get_joint(monster)
	var m_a = monster_joint.node_a
	var m_b = monster_joint.node_b
	
	var next_node = get_node(m_b)
	var next_node_joint:Joint2D = get_joint(next_node)
	
	next_node.mode=RigidBody2D.MODE_STATIC
	monster.move_to_global_position(next_node.global_position)

var moving_up=false
func move_monster_up_swap():
	#if moving_up:
	#	return
	moving_up=true
	var monster_joint: Joint2D = get_joint(monster)
	var m_a = monster_joint.node_a
	var m_b = monster_joint.node_b
	
	var toAdd = LighRes.instance()
	get_parent().add_child(toAdd)

	var next_node = get_node(m_b)
	var next_node_joint:Joint2D = get_joint(next_node)
	
	var tmp_n_b=next_node_joint.node_b
	var tmp_n_pos=next_node.global_position
	toAdd.global_position = tmp_n_pos
	
	#next_node_joint.node_a = next_node.get_path()
	#next_node_joint.node_b = monster.get_path()
	next_node.queue_free()
	$Line2D.remove_point(0)
	
	#monster_joint.node_a=monster.get_path()
	monster_joint.node_b=tmp_n_b
	
	
	#var tmp = monster.global_position
	#monster.global_position = tmp_n_pos
	monster.move_to_global_position(tmp_n_pos)
	#next_node.global_position=tmp
	#$Timer.start()

func _on_Timer_timeout():
	moving_up=false

	

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
	for _loop_index in range (1+count):
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

func get_link(linkIndex):
	return $Chain.get_child(linkIndex)
func has_link(linkIndex):
	return $Chain.get_child_count() > linkIndex and linkIndex >= 0


