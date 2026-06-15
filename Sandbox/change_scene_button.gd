extends Button

@export var transition_data : SceneTransitionData
@export var target_scene_path : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	SceneTransitionManager.request_scene_change(transition_data, Static.get_current_scene(get_tree().root), target_scene_path)
