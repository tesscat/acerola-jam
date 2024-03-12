shader_type canvas_item;

uniform sampler2D SCREEN_TEX : hint_screen_texture;
const float theta = 0.0;

const vec2 pixelSize = vec2(1.0)/vec2(960.0, 540.0);
const float pxRadius = 7.0;

const vec3 cyan = normalize(vec3(0.0, 1.0, 1.0));
const vec3 magenta = normalize(vec3(1.0, 0.0, 1.0));
const vec3 yellow = normalize(vec3(1.0, 1.0, 0.0));

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 coordsOffs = pixelSize * pxRadius * vec2(cos(theta), sin(theta));
	float c = 1.0 - texture(SCREEN_TEX, SCREEN_UV + coordsOffs).r;
	float m = 1.0 - texture(SCREEN_TEX, SCREEN_UV - coordsOffs).g;
	float y = 1.0 - texture(SCREEN_TEX, SCREEN_UV).b;
	
	vec3 co = (vec3(c*cyan + m*magenta + y*yellow));
	co /= (tanh(length(co) - 0.2) * 1.5);
	co = clamp(co, 0.0, 1.0);
	// try and preserve brightness
	// bring the whites down
	COLOR.rgb = (vec3(1.0 - co));
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
