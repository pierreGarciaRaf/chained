extends KinematicBody2D

var velocity = Vector2.ZERO

var chain


var player : KinematicBody2D
export var playerPath : NodePath

var requiredDistance = 2.0

var pathToFollow : PoolVector2Array
var pathPointIndex = 0
var lastPlayerPos : Vector2

onready var lightRes = preload("res://src/world/environment/light/generalLight.tscn")
onready var magicChainRes = preload("res://src/world/magicChain/magicChain.tscn")

export var speed = 150

export var nav2DPath:NodePath
var distJump = 64

var nav2D:Navigation2D

signal player_dead

var chainFollowShower

var torchToPutOut : Node2D = null 

func _ready():
	chainFollowShower = lightRes.instance()
	get_parent().call_deferred("add_child",chainFollowShower)
	player = get_node(playerPath)
	nav2D = get_node(nav2DPath)
	build_chain_to_player(nav2D)






func get_to_player():
	if has_to_change_path():
		pathToFollow = nav2D.get_simple_path(self.position, player.position)
		pathPointIndex = 1
		lastPlayerPos = player.position
	elif has_to_change_index():
		pathPointIndex +=1
		pathPointIndex = min(pathPointIndex, pathToFollow.size()-1)
	
	velocity = speed * global_position.direction_to(pathToFollow[pathPointIndex])

func jump_on_player():
	velocity = speed * 2 * global_position.direction_to(player.global_position)

func has_to_change_path():
	return pathToFollow == null or pathToFollow.size() <= 1 or lastPlayerPos.distance_to(player.global_position) > requiredDistance

func has_to_change_index():
	return (pathToFollow[pathPointIndex] - self.position).length() < requiredDistance

func idle():
	velocity = Vector2.ZERO


func build_chain_to_player(navigation2D : Navigation2D):
	chain = magicChainRes.instance()
	chain.monster = self
	chain.player = player
	chain.build()
	get_parent().call_deferred("add_child",chain)



func isChainTensed():
	return chain.is_chain_tensed()



func canJumpOnPlayer():
	var collider = $jumpRcast.get_collider()
	return collider != null and collider == player

func _applyVelocity(delta):
	var col = self.move_and_collide(velocity * delta)
	if col:
		if col.collider.name == "player":
			emit_signal("player_dead")
	var vectToPlayer = player.global_position - self.global_position
	if vectToPlayer.length() < distJump:
		$jumpRcast.enabled = true
		$jumpRcast.cast_to = vectToPlayer*2
	else:
		$jumpRcast.enabled = false



func _onSeeingTorch(torch):
	print("seesTorch")
	torchToPutOut = torch

func get_to_torch():
	velocity = self.global_position.direction_to(torchToPutOut.global_position)*speed/2

func close_enough_to_torch():
	return self.global_position.distance_to(torchToPutOut.global_position) < requiredDistance

func put_out_torch():
	torchToPutOut.kill()
	torchToPutOut = null




