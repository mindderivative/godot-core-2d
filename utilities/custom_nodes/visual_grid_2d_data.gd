@tool
class_name VisualGrid2DData extends Resource

signal visual_grid_2d_data_updated

#region Exported Variables
@export_range(1.0, 1000.0, 1.0) var grid_size : float = 100.0 :
	get:
		return grid_size
	set(value):
		if grid_size != value:
			grid_size = value
			visual_grid_2d_data_updated.emit()
@export var grid_color : Color = Color(1.0, 1.0, 1.0, 0.3) :
	get:
		return grid_color
	set(value):
		if grid_color != value:
			grid_color = value
			visual_grid_2d_data_updated.emit()
@export_range(-1.0, 10.0, 1.0) var line_width : float = -1.0 :
	get:
		return line_width
	set(value):
		if line_width != value:
			line_width = value
			visual_grid_2d_data_updated.emit()

@export_group("Grid Bounds")
@export_range(10, 100, 1, "suffix:tiles") var extend_grid_tiles : int = 100 :
	get:
		return extend_grid_tiles
	set(value):
		if extend_grid_tiles != value:
			extend_grid_tiles = value
			visual_grid_2d_data_updated.emit()

@export_group("Performance")
@export var adaptive_culling : bool = true :
	get:
		return adaptive_culling
	set(value):
		if adaptive_culling != value:
			adaptive_culling = value
			visual_grid_2d_data_updated.emit()
@export var update_threshold : float = 1000.0 :
	get:
		return update_threshold
	set(value):
		if update_threshold != value:
			update_threshold = value
			visual_grid_2d_data_updated.emit()
@export var max_lines_per_frame : int = 1000 :
	get:
		return max_lines_per_frame
	set(value):
		if max_lines_per_frame != value:
			max_lines_per_frame = value
			visual_grid_2d_data_updated.emit()
#endregion
