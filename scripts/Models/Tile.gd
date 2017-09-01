const TILETYPE = {"Empty":-1, "Floor":0}
var _tile_type = -1 setget set_tile_type, get_tile_type
var world
var position = Vector2()
signal tile_type_changed


func _init(_world, _position):
	world = _world
	position = _position


func set_tile_type(value):
	_tile_type = value
	emit_signal("tile_type_changed")


func get_tile_type():
	return _tile_type
