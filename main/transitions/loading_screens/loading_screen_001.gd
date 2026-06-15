extends Control

#region Signals
signal loading_finished
#endregion

#region Export Variables
@export var loading_screen_data : LoadingScreenData
#endregion

#region Variables
var _progress_bar_ref : ProgressBar = null
#endregion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.name = "LoadingScreen"
	z_index = 5

func set_progress(percent : float) -> void:
	if not _progress_bar_ref:
		push_error("_progress_bar_ref is null.")
		return
	
	_progress_bar_ref.value = int(percent * 100)
	Static.printc(self.name, Color.CADET_BLUE, "Loading progress: ", _progress_bar_ref.value)

func start_loading() -> void:
	Static.printc(self.name, Color.CADET_BLUE, "Starting loading screen...")
	if not loading_screen_data or not loading_screen_data.enabled:
		Static.printc(self.name, Color.CADET_BLUE, "No loading screen data or not enabled, emitting loading_finished immediately.")
		loading_finished.emit()
		return
	
	var progress_bar : ProgressBar = null
	if not loading_screen_data.progress_bar_path.is_empty():
		progress_bar = get_node_or_null(loading_screen_data.progress_bar_path)
	
	if progress_bar:
		loading_screen_data.set_styles(progress_bar)
		progress_bar.show_percentage = loading_screen_data.progress_bar_show_percentage
		progress_bar.value = 0
		_progress_bar_ref = progress_bar
	
	if progress_bar:
		var tween : Tween = create_tween()
		tween.tween_property(progress_bar, "value", 100, max(loading_screen_data.duration, 0.5)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		await tween.finished
		Static.printc(self.name, Color.CADET_BLUE, "Progress 100% complete.")
	else:
		await get_tree().create_timer(max(loading_screen_data.duration, 0.5)).timeout
		Static.printc(self.name, Color.CADET_BLUE, "Progress 100% complete using timer.")
	Static.printc(self.name, Color.CADET_BLUE, "Loading finished, emitting [loading_finished] signal.")
	loading_finished.emit()
