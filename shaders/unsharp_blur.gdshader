shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE;

void vertex() {
	// Called for every vertex the material is visible on.
}

const float boxRadius = 1.0;
const vec2 pxSize = vec2(1.0)/vec2(960.0, 540.0);

void fragment() {
	vec3 out_col = vec3(0.0);
	for (float x = -boxRadius; x <= boxRadius; x++) {
		for (float y = -boxRadius; y <= boxRadius; y++) {
			out_col += texture(SCREEN_TEXTURE, SCREEN_UV + pxSize * vec2(x, y)).rgb;
		}
	}
	COLOR.rgb = out_col / pow(2.0*boxRadius + 1.0, 2);
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
