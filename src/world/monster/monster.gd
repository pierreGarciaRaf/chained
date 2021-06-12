extends KinematicBody2D

var velocity = Vector2.ZERO

var chain : Chain


var player : KinematicBody2D
export var playerPath : NodePath

var target_pos : Vector2
var requiredDistance = 10.0

var timeIChangedLink = 0 #for debug
onready var lightRes = preload("res://src/world/environment/torch/generalLight.tscn")

onready var chainRes = preload("res://src/world/chain/Chain.tscn")

export var speed = 110

var chainFollowShower

func _applyVelocity():
	velocity = self.move_and_slide(velocity)

func get_up_the_chain():
	if has_to_change_target_link_pos():
		timeIChangedLink += 1
		print(timeIChangedLink)
		if not isChainFinished():
			target_pos = (chain.get_link(timeIChangedLink) as RigidBody2D).global_position
			chainFollowShower.position = target_pos
		else:
			chainFollowShower.position = Vector2.ONE * -5000
	var directionToGoTo = (target_pos - self.position).normalized()
	velocity = directionToGoTo * speed

func has_to_change_target_link_pos():
	return (target_pos - self.position).length() < requiredDistance



func idle():
	velocity = Vector2.ZERO

func _ready():
	chainFollowShower = lightRes.instance()
	get_parent().call_deferred("add_child",chainFollowShower)
	player = get_node(playerPath)
	build_chain_to_player()

func build_chain_to_player():
	chain = chainRes.instance()
	
	chain.monster = self
	chain.player = player


	chain.points = PoolVector2Array([self.position, player.position])
	get_parent().call_deferred("add_child",chain)


func isChainTensed():
	return chain.is_chain_tensed()



func isChainFinished():
	return not chain.has_link(timeIChangedLink)
