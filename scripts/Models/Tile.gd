const TILETYPE = {"Empty":-1, "Floor":0}
var _tile_type = -1 setget set_tile_type, get_tile_type
var world
var x
var y
signal tile_type_changed


func _init(_world, _x, _y):
	world = _world
	x = _x
	y = _y


func set_tile_type(value):
	_tile_type = value
	emit_signal("tile_type_changed")


func get_tile_type():
	return _tile_type
