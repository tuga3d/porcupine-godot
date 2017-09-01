var Tile = load("res://scripts/Models/Tile.gd")
var level = []
var width
var height


func _init(_width=100, _height=100):
	width = _width
	height = _height

	# fill level array with tile objects
	for x in range(width):
		var _temp = []
		for y in range(height):
			_temp.append(Tile.new(self, x, y))
		level.append(_temp)


func randomize_tiles():
	for x in range(width):
		for y in range(height):
			if randi() % 2 == 0:
				level[x][y].set_tile_type(Tile.TILETYPE.Empty)
			else:
				level[x][y].set_tile_type(Tile.TILETYPE.Floor)


func get_tile_at(x, y):
	if x > width or x < 0 or y > height or y < 0:
		print("Tile %d, %d is out of range." % [x, y])
		return null
	return level[x][y]
