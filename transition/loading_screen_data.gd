class_name LoadingScreenData extends Resource

@export_category("Loading Screen Settings")
@export var enabled: bool = true
@export var auto_start: bool = true
@export var duration: float = 0.0
@export var wait_for_input: bool = false
@export var input_action: String = "ui_accept"
@export var block_input: bool = true

@export_subgroup("Progress Bar Settings", "Loading Screen Settings")
@export var progress_bar_path: NodePath = NodePath("ProgressBar")
@export var progress_bar_show_percentage: bool = true
@export var background_stylebox: StyleBoxFlat
@export var fill_stylebox: StyleBoxFlat

func set_styles(progress_bar: ProgressBar) -> void:
	if background_stylebox:
		progress_bar.add_theme_stylebox_override("background", background_stylebox)
	if fill_stylebox:
		progress_bar.add_theme_stylebox_override("fill", fill_stylebox)
