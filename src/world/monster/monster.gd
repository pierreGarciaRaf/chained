extends KinematicBody2D

var velocity = Vector2.ZERO

var chain : Chain


var player : KinematicBody2D
export var playerPath : NodePath

var target_link:Node2D
var requiredDistance = 50.0

var timeIChangedLink = 0 #for debug

onready var chainRes = preload("res://src/world/chain/Chain.tscn")

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
	return chain

func idle():
	velocity = Vector2.ZERO

func _ready():
	player = get_node(playerPath)
	build_chain_to_player()

func build_chain_to_player():
	chain = chainRes.instance()
	
	chain.monster = self
	chain.player = player
	var lightRes = preload("res://src/world/environment/torch/generalLight.tscn")
	var toAdd1 = lightRes.instance()
	toAdd1.position = self.position
	var toAdd2 = lightRes.instance()
	toAdd2.position = player.position
	get_parent().call_deferred("add_child",toAdd1 )
	get_parent().call_deferred("add_child",toAdd2 )
	chain.points = PoolVector2Array([self.position, player.position])
	get_parent().call_deferred("add_child",chain)
