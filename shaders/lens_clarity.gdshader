shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE;
uniform sampler2D DEPTH_TEXTURE;
uniform vec3 tint;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
