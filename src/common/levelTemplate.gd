extends Node2D


export var tileMapPath : NodePath
var tileMap : TileMap

var monster : Monster
var player
var guillotine

func _ready():
	get_tree().paused = false
	
	tileMap = get_node(tileMapPath)
	var tileMapForLightRcast :TileMap= tileMap.duplicate()
	tileMap.visible = true
	tileMapForLightRcast.visible = false
	tileMapForLightRcast.set_collision_layer_bit(4,true)
	tileMapForLightRcast.name = "lightRcastMap"
	
	tileMapForLightRcast.show_collision = true
	(tileMapForLightRcast).tile_set = preload("res://src/world/environment/walls&Floor/blueTilesetLightCollisions.tres")
	tileMap.get_parent().add_child(tileMapForLightRcast)
	
	# Referencing key children
	player=get_node('player')
	monster=get_node('monster')
	
	monster.connect('player_dead',self, 'on_player_dead')
	
	guillotine = get_node("Guillotine")
	if guillotine:
		guillotine.connect('guillotine_entered',self,'on_guillotine_entered')
		guillotine.connect('safe_place_entered',self,'on_safe_place_entered')
		guillotine.connect('guillotine_fallen',self,'on_guillotine_fallen')
	else:
		print('WARNING : no guillotine')
		

func on_guillotine_entered(body):
	print('body entered guillotine', body)
	if body== player:
		print('Player about to win')
	if body== monster:
		print('Monster killed')
		#monster.killed_by_guillotine()
		guillotine.fall()
		#end_of_level(), unlock next level
		
		
func on_safe_place_entered(body):
	print('Player wins; cut the chain')
	guillotine.fall()
	#break_chain(guillotine.global_position)
	#end_of_level(), unlock next level

func on_guillotine_fallen():
	end_level()

func on_player_dead():
	if get_tree().paused:
		return
	print('player dead')
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	$CanvasLayer/DeathPopup.popup_centered()

func end_level():
#	$CanvasModulate.visible=false # otherwise popup is hidden
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	
	$CanvasLayer/EndLevelPopup.popup_centered()
