shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE;

void vertex() {
	// Called for every vertex the material is visible on.
}


const float dilate_window_size = 4.0;

const vec2 pxSize = (1.0/vec2(960.0, 540.0));

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 outc;
	float maxBr = -1.0;
	
	vec3 blurCol = vec3(0);
	
	// we merge the two for loops
	
	for (float x = -dilate_window_size; x <= dilate_window_size; x++) {
		for (float y = -dilate_window_size; y <= dilate_window_size; y++) {
			vec3 ccol = texture(SCREEN_TEXTURE, SCREEN_UV + pxSize * vec2(x, y)).rgb;
			float col_brightness = ccol.x + ccol.y + ccol.z;
			if (col_brightness > maxBr) {
				outc = ccol;
				maxBr = col_brightness;
			}
		}
	}
	
	
	COLOR.rgb = outc;
	COLOR.a = 1.0;
	// COLOR.rgb = vec3(1.0, 0.0, 1.0);
	// COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
