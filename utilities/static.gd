class_name Static extends RefCounted

static var PREVIOUS_SCENE_CONTAINER : NodePath = "/root/Main/World/PreviousScene"

static func printc(prefix : String, color : Color = Color.GREEN, ...args) -> void:
	var output : String = "[color=" + color.to_html() + "]" + prefix + ":[/color] "
	
	for i in range(args.size()):
		output += str(args[i])
		if i < args.size() - 1:
			output += " "
	
	print_rich(output)

static func get_current_scene(root : Node) -> NodePath:
	if root.get_node_or_null("Main/World/CurrentScene").get_child_count() > 0:
		return root.get_node_or_null("Main/World/CurrentScene").get_child(0).get_path()
	return root.get_node_or_null("Main/World/CurrentScene").get_path()

static func get_transitions(root : Node) -> NodePath:
	return root.get_node_or_null("Main/Transitions").get_path()
