extends Node2D

var monster:KinematicBody2D
var player:KinematicBody2D

var tenseDist = 200

func build():
	$Line2D.add_point(monster.global_position)
	$Line2D.add_point(player.global_position)

func _ready():
	pass

func _process(delta):
	$Line2D.set_point_position(0, monster.global_position)
	$Line2D.set_point_position(1, player.global_position)

func is_chain_tensed():
	return monster.global_position.distance_to(player.global_position) > tenseDist
