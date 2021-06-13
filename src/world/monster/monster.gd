extends KinematicBody2D
class_name Monster

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
var requiredDistForPath = 2
var distJump = 32+16

var nav2D:Navigation2D

var pathVisualRepresentation : Line2D

signal player_dead


var torchToPutOut : Node2D = null 

func _ready():
	player = get_node(playerPath)
	nav2D = get_node(nav2DPath)
	build_chain_to_player()






func get_to_player():
	if has_to_change_path():
		pathToFollow = nav2D.get_simple_path(self.position, player.position)
		pathPointIndex = 1
		lastPlayerPos = player.position
		if get_tree().is_debugging_collisions_hint() :
			if pathVisualRepresentation:
				pathVisualRepresentation.queue_free()
			pathVisualRepresentation = Line2D.new()
			pathVisualRepresentation.width = 8
			pathVisualRepresentation.points = pathToFollow
			get_parent().add_child(pathVisualRepresentation)
	elif has_to_change_index():
		pathPointIndex +=1
		pathPointIndex = min(pathPointIndex, pathToFollow.size()-1)
	if pathToFollow.size() > pathPointIndex:
		velocity = speed * global_position.direction_to(pathToFollow[pathPointIndex])

func jump_on_player():
	velocity = speed * 2 * global_position.direction_to(player.global_position)

func has_to_change_path():
	return pathToFollow == null or pathToFollow.size() <= 1 or lastPlayerPos.distance_to(player.global_position) > requiredDistance

func has_to_change_index():
	return (pathToFollow[pathPointIndex] - self.position).length() < requiredDistForPath

func idle():
	velocity = Vector2.ZERO


func build_chain_to_player():
	chain = magicChainRes.instance()
	chain.monster = self
	chain.player = player
	chain.build()
	chain.z_index = 1
	get_parent().call_deferred("add_child",chain)



func isChainTensed():
	return chain.is_chain_tensed()



func canJumpOnPlayer():
	var collider = $jumpRcast.get_collider()
	if collider:
		print(collider.name)
	return collider != null and collider == player

func _applyVelocity(delta):
	return self.move_and_collide(velocity * delta)

func checkForPlayerDeath(col):
	if col:
		if col.collider.name == "player":
			emit_signal("player_dead")

func tryToSeePlayer():
	var vectToPlayer = player.global_position - self.global_position
	if vectToPlayer.length() < distJump:
		$jumpRcast.enabled = true
		$jumpRcast.cast_to = vectToPlayer*2



func _onSeeingTorch(torch):
	torchToPutOut = torch

func get_to_torch():
	velocity = self.global_position.direction_to(torchToPutOut.global_position)*speed/2

func close_enough_to_torch():
	return self.global_position.distance_to(torchToPutOut.global_position) < requiredDistance

func put_out_torch():
	torchToPutOut.kill()
	torchToPutOut = null




