var Tile = load("res://scripts/Models/Tile.gd")
var level = []
var size = Vector2()


func _init(_size=Vector2(100, 100)):
	size = _size

	# fill level array with tile objects
	for x in range(size.x):
		var _temp = []
		for y in range(size.y):
			_temp.append(Tile.new(self, Vector2(x, y)))
		level.append(_temp)


func randomize_tiles():
	for x in range(size.x):
		for y in range(size.y):
			if randi() % 2 == 0:
				level[x][y].set_tile_type(Tile.TILETYPE.Empty)
			else:
				level[x][y].set_tile_type(Tile.TILETYPE.Floor)


func get_tile_at(x, y):
	if x > size.x or x < 0 or y > size.y or y < 0:
		print("Tile %d, %d is out of range." % [x, y])
		return null
	return level[x][y]
