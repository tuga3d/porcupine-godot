extends Node2D

export(Texture) var preview_texture

onready var camera = $camera
onready var world_controller = $"../world_controller"

var zoom_factor = Vector2(0.05, 0.05)
var zoom_limits = Rect2(Vector2(0.1, 0.1), Vector2(3.0, 3.0))
var dragging = false
var box_selecting = false
var selected_area = Rect2()
var selection_border = Color(0.5, 0.5, 0.5, 1)
var selection_fill = Color(0.5, 0.5, 0.5, 0.2)
var build_mode_tile

func _ready():
	$"../UI/VBoxContainer/build_floor".connect("pressed", self, "_on_build_floor_pressed")
	$"../UI/VBoxContainer/bulldoze".connect("pressed", self, "_on_bulldoze_pressed")
	build_mode_tile = world_controller.world.Tile.TILETYPE.Floor


func _unhandled_input(event):
	if event is InputEventMouseButton:
		var button = event.get_button_index()
		if event.is_pressed():
			if button == BUTTON_WHEEL_UP:
				camera_zoom(zoom_factor)
			if button == BUTTON_WHEEL_DOWN:
				camera_zoom(-zoom_factor)
			if button == BUTTON_RIGHT or button == BUTTON_MIDDLE:
				dragging = true
			if button == BUTTON_LEFT:
				selected_area = Rect2(event.position, Vector2())
				box_selecting = true
		else:
			dragging = false
			box_selecting = false
			if selected_area:
				change_tiles()

	if event is InputEventMouseMotion:
		if dragging:
			camera.offset -= event.get_relative() * camera.zoom
		if box_selecting:
			selected_area.end = event.position
			update()
		else:
			selected_area = Rect2()


func _draw():
	if box_selecting:
		var selection = selected_area
		selection.position = selected_area.position * camera.zoom + camera.offset
		selection.end = selected_area.end * camera.zoom + camera.offset
		
		# TODO: remove.
		# draw selection rectangle 
		draw_rect(selection, selection_fill, true)
		draw_rect(selection, selection_border, false)
		
		# draw preview images
		var begin = world_controller.tilemap.world_to_map(selection.position)
		var end = world_controller.tilemap.world_to_map(selection.end)
		for x in range(min(begin.x, end.x), max(begin.x, end.x) + 1):
			for y in range(min(begin.y, end.y), max(begin.y, end.y) + 1):
				draw_texture(preview_texture, world_controller.tilemap.map_to_world(Vector2(x,y)))


func camera_zoom(factor):
	# zoom on mouse position
	var mouse_pos = get_global_mouse_position()
	var old_zoom = camera.zoom
	var new_zoom = camera.zoom - factor
	var old_offset = camera.offset
	var new_offset = (old_offset - mouse_pos) * new_zoom / old_zoom + mouse_pos

	# check limits
	if zoom_limits.has_point(new_zoom):
		camera.zoom = new_zoom
		camera.offset = new_offset


func change_tiles():
	# compensate for camera zoom and offset
	var coord1 = selected_area.position * camera.zoom + camera.offset
	var coord2 = selected_area.end * camera.zoom + camera.offset
	# get tilemap coords
	coord1 = world_controller.tilemap.world_to_map(coord1)
	coord2 = world_controller.tilemap.world_to_map(coord2)

	print("Tiles selected:\nFrom: ", coord1, "\nTo: ", coord2)
	# change cells value
	for x in range(min(coord1.x, coord2.x), max(coord1.x, coord2.x) + 1):
		for y in range(min(coord1.y, coord2.y), max(coord1.y, coord2.y) + 1):
			world_controller.tilemap.set_cell(x, y, build_mode_tile)
	update()


func _on_build_floor_pressed():
	build_mode_tile = world_controller.world.Tile.TILETYPE.Floor


func _on_bulldoze_pressed():
	build_mode_tile = world_controller.world.Tile.TILETYPE.Empty
