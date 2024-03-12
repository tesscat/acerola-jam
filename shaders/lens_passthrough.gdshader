shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE;

void fragment() {
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
