extends Control

@export var start_button : Button
@export var settings_button : Button
@export var exit_button : Button

@export var transition_data : SceneTransitionData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	SceneTransitionManager.new_scene_loaded.connect(_on_new_scene_loaded)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#region Signal functions
func _on_start_button_pressed() -> void:
	SceneTransitionManager.request_scene_change(transition_data, Static.get_current_scene(get_tree().root), LevelManager.galactic_system)

func _on_settings_button_pressed() -> void:
	pass

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_new_scene_loaded() -> void:
	print("new scene loaded")
	queue_free()
#endregion
