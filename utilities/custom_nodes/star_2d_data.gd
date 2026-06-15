@tool
class_name Star2DData extends Resource

signal star_2d_data_updated(property : String)

#region Export Variables
@export_group("Star")
@export var star_texture : CompressedTexture2D :
	get:
		return star_texture
	set(value):
		if star_texture != value:
			star_texture = value
			star_2d_data_updated.emit("star_texture")
@export var star_ring_texture : CompressedTexture2D :
	get:
		return star_ring_texture
	set(value):
		if star_ring_texture != value:
			star_ring_texture = value
			star_2d_data_updated.emit("star_ring_texture")
@export var star_material : ShaderMaterial :
	get:
		return star_material
	set(value):
		if star_material != value:
			star_material = value
			star_2d_data_updated.emit("star_material")
@export var star_self_modulate : Color = Color.WHITE :
	get:
		return star_self_modulate
	set(value):
		if star_self_modulate != value:
			star_self_modulate = value
			star_2d_data_updated.emit("star_self_modulate")
@export_group("Star Label")
@export var star_label_settings : LabelSettings :
	get: return star_label_settings
	set(value):
		if star_label_settings != value:
			star_label_settings = value
			star_2d_data_updated.emit("star_label_settings")
@export var star_name : String = "Unamed Star" :
	get:
		return star_name
	set(value):
		if star_name != value:
			star_name = value
			star_2d_data_updated.emit("star_name")
@export var star_label_modulate : Color = Color(1,1,1,0) :
	get:
		return star_label_modulate
	set(value):
		if star_label_modulate != value:
			star_label_modulate = value
			star_2d_data_updated.emit("star_label_modulate")
@export var star_label_fade_enabled : bool = true :
	get: return star_label_fade_enabled
	set(value):
		if star_label_fade_enabled != value:
			star_label_fade_enabled = value
			if star_label_fade_enabled:
				star_label_modulate.a = 0.0
			else:
				star_label_modulate.a = 1.0
			star_2d_data_updated.emit("star_label_fade_enabled")
@export var star_label_tween_duration : float = 0.25 :
	get: return star_label_tween_duration
	set(value):
		if star_label_tween_duration != value:
			star_label_tween_duration = value
			star_2d_data_updated.emit("star_label_tween_duration")
@export var star_label_offset : Vector2 = Vector2.ZERO :
	get: 
		return star_label_offset
	set(value):
		if star_label_offset != value:
			star_label_offset = value
			star_2d_data_updated.emit("star_label_offset")
@export var star_label_anchor : Control.LayoutPreset = Control.PRESET_CENTER :
	get: return star_label_anchor
	set(value):
		if star_label_anchor != value:
			star_label_anchor = value
			star_2d_data_updated.emit("star_label_anchor")
#endregion

#region Variables

#endregion
