@tool
class_name TestOmniLight
extends QodotEntity

func update_properties():
	if not Engine.is_editor_hint():
		return
	
	for child in get_children():
		remove_child(child)
		child.queue_free()
		
	var light_node = self # as OmniLight3D # OmniLight3D.new()
	
	print_debug(properties)
	
	if "light_color" in properties:
		var components = properties["light_color"].split(" ")
		light_node.light_color = Color(float(components[0])/256, float(components[1])/256, float(components[2])/256)
	if "range" in properties:
		light_node.omni_range = properties["range"]
	if "shadow_enabled" in properties:
		light_node.shadow_enabled = (properties["shadow_enabled"] == "true")
	if "energy" in properties:
		light_node.light_energy = properties["energy"]
	
	# light_node.set_param(Light3D.PARAM_ATTENUATION, attenuation)
	# light_node.set_shadow(true)
	light_node.set_bake_mode(Light3D.BAKE_STATIC)
