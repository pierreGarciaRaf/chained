extends Node2D


export var tileMapPath : NodePath
var tileMap : TileMap

func _ready():
	tileMap = get_node(tileMapPath)
	var tileMapForLightRcast :TileMap= tileMap.duplicate()
	tileMap.visible = true
	print(tileMap.get_collision_layer_bit(0))
	tileMapForLightRcast.visible = false
	tileMapForLightRcast.set_collision_layer_bit(4,true)
	print(tileMapForLightRcast.get_collision_layer_bit(4))
	
	tileMapForLightRcast.show_collision = true
	(tileMapForLightRcast).tile_set = preload("res://src/world/environment/walls&Floor/groundPlaceHolderForLightRcastColl.tres")
	tileMap.get_parent().add_child(tileMapForLightRcast)
