@tool
class_name VisualGrid2D extends Node2D

#region Exported Variables

@export var enabled : bool = true :
	get:
		return enabled
	set(value):
		if enabled != value:
			enabled = value
			queue_redraw()
@export_group("Major Grid")
@export var major_grid_size : int = 256 :
	get: return major_grid_size
	set(value):
		if major_grid_size != value:
			major_grid_size = value
			queue_redraw()
@export var major_line_width : float = -1.0 :
	get: return major_line_width
	set(value):
		if major_line_width != value:
			major_line_width = value
			queue_redraw()
@export_group("Minor Grid")
@export var minor_grid_size : int = 64 :
	get: return minor_grid_size
	set(value):
		if minor_grid_size != value:
			minor_grid_size = value
			queue_redraw()
@export var minor_line_width : float = -1.0 :
	get: return minor_line_width
	set(value):
		if minor_line_width != value:
			minor_line_width = value
			queue_redraw()
#endregion

#region Variables
var last_draw_position : Vector2 = Vector2.INF
var needs_redraw : bool = true
var last_position : Vector2 = Vector2.ZERO
var camera : Camera2D = null
#endregion

#region Drawing Functions
func _draw() -> void:
	if not enabled:
		return
	
	# 1. Get the camera's view bounds in world space
	# This accounts for position, rotation, and zoom automatically.
	var inv_trans = get_viewport_transform().affine_inverse()
	var screen_rect = get_viewport_rect()
	
	# Top-left and bottom-right corners of the screen in the world
	var view_begin = inv_trans * Vector2.ZERO
	var view_end = inv_trans * screen_rect.size
	
	# 2. Draw our two grid layers
	# Major Grid (Every 256 units)
	_draw_grid_line(view_begin, view_end, major_grid_size, Color(1.0, 0, 0), major_line_width)
	# Minor Grid (Every 64 units)
	_draw_grid_line(view_begin, view_end, minor_grid_size, Color(0.5, 0, 0), minor_line_width)
	
#endregion

func _data_updated() -> void:
	queue_redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not enabled:
		self.visible = false
		return
	
	if not self.visible:
		self.visible = true
	
	queue_redraw()

func _draw_grid_line(v_begin : Vector2, v_end : Vector2, step : int, id_color : Color, width : float) -> void:
	# Find the exact start and end points for the loop
	# fposmod or floor logic ensures the grid stays "anchored" to world (0,0)
	var start_x = floor(v_begin.x / step) * step
	var end_x = ceil(v_end.x / step) * step
	var start_y = floor(v_begin.y / step) * step
	var end_y = ceil(v_end.y / step) * step

	# We add one extra 'step' to the bounds to prevent lines from 
	# "popping" in at the very edge of the screen
	
	# Vertical lines
	for x in range(int(start_x), int(end_x) + step, step):
		draw_line(Vector2(x, v_begin.y), Vector2(x, v_end.y), id_color, width)
		
	# Horizontal lines
	for y in range(int(start_y), int(end_y) + step, step):
		draw_line(Vector2(v_begin.x, y), Vector2(v_end.x, y), id_color, width)
