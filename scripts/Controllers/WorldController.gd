extends Node2D

onready var tilemap = get_node("tilemap")
var world = load("res://scripts/Models/World.gd").new()
var selected_tiles = []


func _ready():
	world.randomize_tiles()
	_update_level()


func _update_level():
	# update cells type
	for x in range(world.width):
		for y in range(world.height):
			tilemap.set_cell(x, y, world.get_tile_at(x, y).get_tile_type())
