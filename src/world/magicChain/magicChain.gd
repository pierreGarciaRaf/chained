extends Node2D

var monster:KinematicBody2D
var player:KinematicBody2D

var tenseDist = 200
var baseWidth = 16
var minWidthProp = .2
var tenseTrhesholdForEffectsToAppear = .4

func build():
	$Line2D.clear_points()
	$Line2D.add_point(monster.global_position)
	$Line2D.add_point(player.global_position)

func _ready():
	Engine.set_time_scale(0.25)
	pass

func getChainLength():
	return monster.global_position.distance_to(player.global_position)

func _process(delta):
	$Line2D.set_point_position(0, monster.global_position)
	$Line2D.set_point_position(1, player.global_position)
	
	var pente = (1.0)/(tenseTrhesholdForEffectsToAppear + minWidthProp)
	
	var tenseFactor = getChainLength()/tenseDist
	tenseFactor =  (1-tenseFactor)/(tenseTrhesholdForEffectsToAppear/(1-minWidthProp)) + minWidthProp
	tenseFactor = clamp(tenseFactor, minWidthProp, 1.0)
	
	$Line2D.material.set("shader_param/tenseFactor", tenseFactor)

	print(tenseFactor)
	

func is_chain_tensed():
	return getChainLength() > tenseDist
