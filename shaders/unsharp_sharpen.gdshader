shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE;
uniform sampler2D BLURRED_TEXTURE : hint_screen_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// get difference between blurred + me
	vec3 delta = abs(texture(SCREEN_TEXTURE, SCREEN_UV).rgb - texture(BLURRED_TEXTURE, SCREEN_UV).rgb);
	// how different are we?
	float d = length(delta);
	COLOR.rgb = texture(SCREEN_TEXTURE, SCREEN_UV).rgb * (1.0 + 10.0*d);
	// COLOR.rgb = delta;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
