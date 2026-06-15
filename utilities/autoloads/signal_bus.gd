extends Node

class iPanZoom:
	signal can_pan_and_zoom(value : bool)

var PanZoom : iPanZoom = iPanZoom.new()
