@tool
class_name Star2D extends Sprite2D

#region Export Variables
@export var enabled : bool = true :
	get:
		return enabled
	set(value):
		if enabled != value:
			enabled = value
			visible = enabled

@export var star_2d_data : Star2DData :
	get:
		return star_2d_data
	set(value):
		if star_2d_data != value:
			star_2d_data = value
			star_2d_data.star_2d_data_updated.connect(_on_star_2d_data_updated)
			if Engine.is_editor_hint():
				_initialize_star_2d_data()
#endregion

#region Variables
var star_ring : Sprite2D
var star_label : Label
var star_area : Area2D
var star_area_shape : CollisionShape2D
var tween_duration : float = 0.25
var fade_enabled : bool
#endregion
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		if has_node("StarRing"):
			star_ring = get_node("StarRing")
		else:
			star_ring = Sprite2D.new()
			star_ring.name = "StarRing"
			self.add_child(star_ring, true)
			star_ring.owner = get_tree().edited_scene_root
		
		if has_node("StarLabel"):
			star_label = get_node("StarLabel")
		else:
			star_label = Label.new()
			star_label.name = "StarLabel"
			star_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			star_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			star_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
			star_label.self_modulate = Color(1,1,1,0)
			self.add_child(star_label, true)
			star_label.owner = get_tree().edited_scene_root
		
		if has_node("StarArea"):
			star_area = get_node("StarArea")
		else:
			star_area = Area2D.new()
			star_area.name = "StarArea"
			self.add_child(star_area, true)
			star_area.owner = get_tree().edited_scene_root
		
		if has_node("StarArea/StarAreaShape"):
			star_area_shape = get_node("StarArea/StarAreaShape")
		else:
			star_area_shape = CollisionShape2D.new()
			star_area_shape.name = "StarAreaShape"
			star_area_shape.shape = CircleShape2D.new()
			star_area.add_child(star_area_shape, true)
			star_area_shape.owner = get_tree().edited_scene_root

	
	star_area = $StarArea
	star_ring = $StarRing
	star_label = $StarLabel
	star_area_shape = $StarArea/StarAreaShape
	if star_2d_data:
		tween_duration = star_2d_data.star_label_tween_duration
		fade_enabled = star_2d_data.star_label_fade_enabled
	
	if star_area:
		star_area.mouse_shape_entered.connect(_on_mouse_entered_star_area)
		star_area.mouse_shape_exited.connect(_on_mouse_exited_star_area)
	
	if star_2d_data and !star_2d_data.star_2d_data_updated.is_connected(_on_star_2d_data_updated):
		star_2d_data.star_2d_data_updated.connect(_on_star_2d_data_updated)

func _initialize_star_2d_data() -> void:
	if star_2d_data.star_texture or texture != star_2d_data.star_texture:
		texture = star_2d_data.star_texture
	if star_2d_data.star_material or material != star_2d_data.star_material:
		material = star_2d_data.star_material
	if star_2d_data.star_self_modulate or self_modulate != star_2d_data.star_self_modulate:
		self_modulate = star_2d_data.star_self_modulate
		star_ring.self_modulate = star_2d_data.star_self_modulate
	if star_2d_data.star_ring_texture or star_ring.texture != star_2d_data.star_ring_texture:
		star_ring.texture = star_2d_data.star_ring_texture
		if star_area_shape.shape is CircleShape2D:
			star_area_shape.shape.radius = star_2d_data.star_ring_texture.get_size().x * 0.5
	if star_2d_data.star_label_settings:
		star_label.label_settings = star_2d_data.star_label_settings
	if star_2d_data:
		star_label.text = star_2d_data.star_name
		star_label.set_anchors_and_offsets_preset(star_2d_data.star_label_anchor)
		star_label.self_modulate = star_2d_data.star_label_modulate
		star_2d_data.star_label_offset = star_label.position
		tween_duration = star_2d_data.star_label_tween_duration
		fade_enabled = star_2d_data.star_label_fade_enabled
		

#region Signal Functions
func _on_star_2d_data_updated(property : String) -> void:
	match property:
		"star_texture":
			if texture != star_2d_data.star_texture:
				texture = star_2d_data.star_texture
				if star_area_shape.shape is CircleShape2D:
					_set_star_area_shape()
				_set_star_label_offset()
		"star_material":
			if material != star_2d_data.star_material:
				material = star_2d_data.star_material
		"star_self_modulate":
			if self_modulate != star_2d_data.star_self_modulate:
				self_modulate = star_2d_data.star_self_modulate
				star_ring.self_modulate = star_2d_data.star_self_modulate
		"star_ring_texture":
			if star_ring.texture != star_2d_data.star_ring_texture:
				star_ring.texture = star_2d_data.star_ring_texture
				if star_area_shape.shape is CircleShape2D:
					_set_star_area_shape()
				_set_star_label_offset()
		"star_name":
			if star_label.text != star_2d_data.star_name:
				star_label.text = star_2d_data.star_name
		"star_label_modulate":
			if star_label.self_modulate != star_2d_data.star_label_modulate:
				star_label.self_modulate = star_2d_data.star_label_modulate
		"star_label_offset":
			if star_label.position != star_2d_data.star_label_offset:
				star_label.set_position(star_2d_data.star_label_offset, false)
		"star_label_anchor":
			star_label.set_anchors_and_offsets_preset(star_2d_data.star_label_anchor)
			star_2d_data.star_label_offset = star_label.position
		"star_label_settings":
			star_label.label_settings = star_2d_data.star_label_settings
			_set_star_label_offset()
		"star_label_tween_duration":
			tween_duration = star_2d_data.star_label_tween_duration
		"star_label_fade_enabled":
			fade_enabled = star_2d_data.star_label_fade_enabled
			#if fade_enabled:
				#star_2d_data.star_label_modulate.a = 0.0
			#else:
				#star_2d_data.star_label_modulate.a = 1.0
			

func _on_mouse_entered_star_area(shape_idx : int) -> void:
	# Fade in
	if fade_enabled:
		SignalBus.PanZoom.can_pan_and_zoom.emit(false)
		var tween : Tween = create_tween()
		tween.tween_property(star_label, "self_modulate", Color(1,1,1,1), tween_duration).from_current().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
		#await tween.finished

func _on_mouse_exited_star_area(shape_idx : int) -> void:
	# Fade out
	if fade_enabled:
		SignalBus.PanZoom.can_pan_and_zoom.emit(true)
		var tween : Tween = create_tween()
		tween.tween_property(star_label, "self_modulate", Color(1,1,1,0), tween_duration / 2).from_current().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
		#await tween.finished
#endregion

#region Helper Functions
func _set_star_area_shape() -> void:
	if star_2d_data.star_ring_texture:
		star_area_shape.shape.radius = star_2d_data.star_ring_texture.get_size().x * 0.5
	elif !star_2d_data.star_ring_texture and star_2d_data.star_texture:
		star_area_shape.shape.radius = star_2d_data.star_texture.get_size().x * 0.5
	else:
		star_area_shape.shape.radius = 0.0

func _set_star_label_offset() -> void:
	star_label.set_anchors_and_offsets_preset(star_2d_data.star_label_anchor)
	star_2d_data.star_label_offset = star_label.position
	
	if star_2d_data.star_ring_texture:
		star_2d_data.star_label_offset.y += (star_2d_data.star_ring_texture.get_size().y * 0.5) + 20.0
	elif !star_2d_data.star_ring_texture and star_2d_data.star_texture:
		star_2d_data.star_label_offset.y += (star_2d_data.star_texture.get_size().y * 0.5) + 20.0
#endregion
