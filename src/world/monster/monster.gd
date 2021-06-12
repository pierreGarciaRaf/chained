extends KinematicBody2D

var velocity = Vector2.ZERO

var chain : Chain


var player : KinematicBody2D
export var playerPath : NodePath

var target_pos : Vector2
var requiredDistance = 5.0

var pathToFollow : PoolVector2Array
var pathPointIndex = 0

var timeIChangedLink = 0 #for debug
onready var lightRes = preload("res://src/world/environment/light/generalLight.tscn")

onready var chainRes = preload("res://src/world/chain/Chain.tscn")

export var speed = 110

export var nav2DPath:NodePath
var nav2D:Navigation2D

var chainFollowShower

func _ready():
	chainFollowShower = lightRes.instance()
	get_parent().call_deferred("add_child",chainFollowShower)
	player = get_node(playerPath)
	nav2D = get_node(nav2DPath)
	build_chain_to_player(nav2D)


func _applyVelocity():
	velocity = self.move_and_slide(velocity)



func get_up_the_chain():
	if has_to_change_target_link_pos():
		timeIChangedLink += 1
		print(timeIChangedLink)
		if not isChainFinished():
			target_pos = get_target_position_at(timeIChangedLink)
			pathToFollow = nav2D.get_simple_path(self.global_position,target_pos)
			pathPointIndex = 0
			chainFollowShower.position = target_pos
		else:
			chainFollowShower.position = Vector2.ONE * -5000
	
	if has_to_change_path_index_to_follow():
		pathPointIndex +=1 
	
	var directionToGoTo = (pathToFollow[pathPointIndex] - self.position).normalized()
	velocity = directionToGoTo * speed

func get_target_position_at(loopIndex):
	var loop = chain.get_loop(loopIndex)
	var normal = chain.get_loop_normal(loopIndex)
	var pos = loop.global_position
	var baseTrans = Transform2D.IDENTITY.translated(pos)
	for dist in range(10,0,-2):
		if not self.test_move(baseTrans, dist * normal):
			print("dist : ",dist)
			return pos + dist * normal
		elif not self.test_move(baseTrans, -dist * normal):
			print("dist : ",dist)
			return pos - dist * normal
	print("dist : ", 0)
	return pos
	

func has_to_change_path_index_to_follow():
	return (pathToFollow[pathPointIndex] - self.position).length() < requiredDistance/4

func has_to_change_target_link_pos():
	return (target_pos - self.position).length() < requiredDistance



func idle():
	velocity = Vector2.ZERO




func build_chain_to_player(navigation2D : Navigation2D):
	chain = chainRes.instance()
	chain.monster = self
	chain.player = player
	chain.points = navigation2D.get_simple_path(self.global_position, player.global_position)
	get_parent().call_deferred("add_child",chain)


func isChainTensed():
	return chain.is_chain_tensed()



func isChainFinished():
	return not chain.has_loop(timeIChangedLink)
