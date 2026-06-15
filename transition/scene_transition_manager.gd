extends Node

#region Signals
signal transition_started
signal transition_ended
signal new_scene_async_loading_started
signal new_scene_async_loading_ended
signal new_scene_loaded
signal current_scene_referenced
signal loading_progress(value : float)
#endregion

#region Variables
var _transitions : Node
var _transition_layer : CanvasLayer
var _transition_control : Node
var _transition_container : Node
var _loading_screen_container : Node

var _transition_data : SceneTransitionData
var _transition_screen : Control
var _loading_screen : Control
var _new_scene_path : String
var _new_scene : Resource
var _current_scene : NodePath
var _progress : Array[float] = []
var _is_loading : bool = false
var _new_scene_instance : Node2D
#endregion

#region Virtual functions
func _ready() -> void:
	call_deferred("_create_transition_loading_screen_containers")

func _process(delta: float) -> void:
	if not _is_loading:
		set_process(false)
		return
	
	var status = ResourceLoader.load_threaded_get_status(_new_scene_path, _progress)
	
	match  status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			_loading_screen.set_progress(_progress[0])
			loading_progress.emit(_progress[0])
		
		ResourceLoader.THREAD_LOAD_LOADED:
			_new_scene = ResourceLoader.load_threaded_get(_new_scene_path)
			new_scene_async_loading_ended.emit()
			_is_loading = false
		
		ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			Static.printc(self.name, Color.RED, "Loading failed for: " + _new_scene_path)
			_is_loading = false
#endregion

#region Callable
func request_scene_change(transition_data : SceneTransitionData, current_scene_path : NodePath, new_scene_path : String) -> void:
	if _is_loading:
		return
	
	transition_started.emit()
	_current_scene = current_scene_path
	_new_scene_path = new_scene_path
	_transition_data = transition_data
	
	var error = ResourceLoader.load_threaded_request(new_scene_path)
	if error != OK:
		Static.printc(self.name, Color.RED, "Failed to start loading: " + new_scene_path)
		transition_ended.emit()
		return
		
	await _initialize_transition()
	await _transition_screen.take_screenshot()
	await _initialize_loading()
	
	new_scene_async_loading_started.emit()
	_is_loading = true
	_perform_scene_transition()
#endregion

#region Initialize transition controls
func _create_transition_loading_screen_containers() -> void:
	if not get_tree().root.get_node_or_null("Main/Transitions"):
		Static.printc(self.name, Color.AQUA, "Setting up transition and loading screen containers...")
		
		_transition_container = Node.new()
		_transition_container.name = "TransitionContainer"
		_loading_screen_container = Node.new()
		_loading_screen_container.name = "LoadingScreenContainer"
		_transitions = Control.new()
		_transitions.name = "Transitions"
		_transitions.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_transition_layer = CanvasLayer.new()
		_transition_layer.name = "TransitionLayer"
		_transition_layer.follow_viewport_enabled = false
		_transition_control = Control.new()
		_transition_control.name = "TransitionControl"
		_transition_control.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		get_tree().root.get_node_or_null("Main").add_child(_transition_control, true)
		_transition_control.add_child(_transition_layer, true)
		_transition_layer.add_child(_transition_control, true)
		_transition_control.add_child(_transition_container, true)
		_transition_control.add_child(_loading_screen_container, true)
	else:
		_transitions = get_node_or_null(Static.get_transitions(get_tree().root))
		_transition_layer = _transitions.get_node_or_null("TransitionLayer")
		_transition_control = _transition_layer.get_node_or_null("TransitionControl")
		_transition_container = _transition_control.get_node_or_null("TransitionContainer")
		_loading_screen_container = _transition_control.get_node_or_null("LoadingScreenContainer")
#endregion

#region Main transitions functions
func _perform_scene_transition() -> void:
	if not _is_loading:
		return
	
	_play_transition()
	await _transition_screen.transition_finished
	
	_remove_transition()
	
	_play_loading()
	set_process(true)
	await _loading_screen.loading_finished
	
	await _initialize_transition()
	await _transition_screen.take_screenshot()
	await get_tree().process_frame
	_remove_loading()
	
	_replace_current_scene()
	
	_play_transition()
	await _transition_screen.transition_finished
	
	_remove_transition()
	
	transition_ended.emit()
#endregion

#region Support functions
func _remove_loading() -> void:
	if _loading_screen:
		_loading_screen.queue_free()
		_loading_screen = null
		Static.printc(self.name, Color.AQUA, "Loading screen removed from scene tree.")

func _remove_transition() -> void:
	if _transition_screen:
		_transition_screen.queue_free()
		_transition_screen = null
		Static.printc(self.name, Color.AQUA, "Transition screen removed from scene tree.")

func _initialize_loading() -> void:	
	if not _transition_data.loading_screen_scene:
		Static.printc(self.name, Color.RED, "No loading screen defined.")
		return

	_loading_screen = _transition_data.loading_screen_scene.instantiate()
	get_tree().root.get_node_or_null(_loading_screen_container.get_path()).add_child(_loading_screen, true)
	Static.printc(self.name, Color.AQUA, "Loading screen [%s] added to scene tree." % _loading_screen)

func _play_loading() -> void:
	if not _loading_screen:
		return
	if _loading_screen.has_signal("loading_finished"):
		_loading_screen.loading_finished.connect(Callable(self, "_on_loading_finished"), CONNECT_ONE_SHOT)
	if _loading_screen.has_method("start_loading"):
		_loading_screen.start_loading()

func _initialize_transition() -> void:
	if not _transition_data.transition_scene:
		Static.printc(self.name, Color.RED, "No transition screen defined.")
		return

	_transition_screen = _transition_data.transition_scene.instantiate()
	get_tree().root.get_node_or_null(_transition_container.get_path()).add_child(_transition_screen, true)
	Static.printc(self.name, Color.AQUA, "Transition screen [%s] added to scene tree." % _transition_screen)
	
func _play_transition() -> void:
	if not _transition_screen:
		return
	if _transition_screen.has_signal("transition_finished"):
		_transition_screen.connect("transition_finished", Callable(self, "_on_transition_finished"), CONNECT_ONE_SHOT)
	if _transition_screen.has_method("start_transition"):
		_transition_screen.start_transition()

func _replace_current_scene() -> void:
	if not _new_scene:
		return
	
	Static.printc(self.name, Color.AQUA, "Replacing current scene with new scene...")
	if _current_scene.is_empty():
		Static.printc(self.name, Color.RED, "No current scene specified for scene replacement.")
		return
	
	var parent := get_tree().root
	var parent_node : Node2D
	
	if not _current_scene.get_name(3) == "CurrentScene":
		var old_node = parent.get_node_or_null(_current_scene)
		
		if not old_node:
			Static.printc(self.name, Color.RED, "Current scene [%s] not found for scene replacement." % _current_scene)
			return
		
		parent_node = old_node.get_parent()
		old_node.queue_free()
	else:
		parent_node = get_node_or_null(_current_scene)
	
	if _new_scene_instance:
		_new_scene_instance.queue_free()
	_new_scene_instance = _new_scene.instantiate()
	parent_node.add_child(_new_scene_instance, true)
	
	new_scene_loaded.emit()
	Static.printc(self.name, Color.AQUA, "New scene [%s] loaded." % _new_scene_path)

#endregion

#region Signal functions
func _on_transition_finished():
	Static.printc(self.name, Color.AQUA, "Signal [transition_ended] emitted.")
	transition_ended.emit()

func _on_loading_finished():
	Static.printc(self.name, Color.AQUA, "New scene loading progress finished.")
#endregion
