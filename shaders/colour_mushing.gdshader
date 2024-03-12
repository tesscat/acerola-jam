shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

uniform bool doColourCorrect;


// make colours less extreme unless they're perfect black, to make it hit harder
void fragment() {
	vec3 currCol = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	if (!doColourCorrect) {
		COLOR.rgb = currCol;
	} else {
		// 0.5 * atan(2x - 1) + 0.5
		// but x is the Nice Length (0 -> 1, not 0 -> sqrt(3))
		float output = atan(2.0 * (length(currCol/sqrt(3.0))) - 1.0);
		currCol = normalize(currCol) * sqrt(3) * (0.5 * output + 0.5);
		COLOR.rgb = currCol;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
