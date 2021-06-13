extends Node2D


export var tileMapPath : NodePath
var tileMap : TileMap

var monster
var player
var guillotine

func _ready():
	tileMap = get_node(tileMapPath)
	var tileMapForLightRcast :TileMap= tileMap.duplicate()
	tileMap.visible = true
	tileMapForLightRcast.visible = false
	tileMapForLightRcast.set_collision_layer_bit(4,true)
	tileMapForLightRcast.name = "lightRcastMap"
	
	tileMapForLightRcast.show_collision = true
	(tileMapForLightRcast).tile_set = preload("res://src/world/environment/walls&Floor/blueTilesetLightCollisions.tres")
	tileMap.get_parent().add_child(tileMapForLightRcast)
	
	player=get_node('player')
	monster=get_node('monster')
	
	guillotine = get_node("Guillotine")
	guillotine.connect('guillotine_entered',self,'on_guillotine_entered')

func on_guillotine_entered(body):
	print('body entered guillotine', body)
	if body== player:
		print('Player win')
	if body== monster:
		print('Monster win')
