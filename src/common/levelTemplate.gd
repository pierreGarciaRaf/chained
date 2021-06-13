extends Node2D


export var tileMapPath : NodePath
var tileMap : TileMap

var monster : Monster
var player
var guillotine

func _ready():
	$CanvasModulate.visible=true
	get_tree().paused = false
	
	tileMap = get_node(tileMapPath)
	var tileMapForLightRcast :TileMap= tileMap.duplicate()
	tileMap.visible = true
	tileMapForLightRcast.visible = false
	tileMapForLightRcast.set_collision_layer_bit(4,true)
	tileMapForLightRcast.name = "lightRcastMap"
	
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
	if body== monster:
		print('Monster killed')
		guillotine.fall()
		
		
func on_safe_place_entered(body):
	print('Player wins; cut the chain')
	guillotine.fall()


func on_guillotine_fallen():
	start_victory_annimation_animation()

func start_victory_annimation_animation():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	$CanvasLayer/VictoryPopup.connect('animation_ended',self,'on_victory_animation_ended')
	$CanvasLayer/VictoryPopup.popup_centered()

	
func on_victory_animation_ended():
	$CanvasLayer/EndLevelPopup.popup_centered()


### Player dead
func on_player_dead():
	if get_tree().paused:
		return
	print('player dead')
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	$CanvasLayer/DeathPopup.popup_centered()
