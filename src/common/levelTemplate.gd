extends Node2D


export var tileMapPath : NodePath
var tileMap : TileMap

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
