shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEX : hint_screen_texture;
uniform sampler2D DEPTH_TEX : hint_depth_texture, repeat_disable, filter_nearest;

// this is a bit messed but c'est la vie
// godot doesn't let you have values greater than or less than 1 for textures
// so we must pack them for accuracy
// NB: anything bigger than 32768 is not going to work well
// so just make it beeg
vec3 packFloat(float a) {
	if (a >= 512.0) return vec3(1.0);
	float h = a + 1.0;
	float j = floor(h)/8.0;
	float k = floor(j)/16.0;
	return fract(vec3(h, j, k));
}

float unpackFloat(vec3 a) {
	return a.r + a.g * 8.0 + a.b * (8.0*16.0);
}

vec3 packFloatInto8BitVec3(float v) {
   float zeroToOne = (v) / (512.0);
   float zeroTo24Bit = zeroToOne * 256.0 * 256.0 * 255.0;
   return vec3(mod(zeroTo24Bit, 256.0) / 256.0, mod(zeroTo24Bit / 256.0, 256.0) / 256.0, zeroTo24Bit / 256.0 / 256.0 / 256.0);
}

float unpack8BitVec3IntoFloat(vec3 v) {
   float zeroTo24Bit = (v.x + v.y * 256.0 + v.z * 256.0 * 256.0) * 256.0;
   float zeroToOne = zeroTo24Bit / 256.0 / 256.0 / 256.0;
   return zeroToOne * (512.0);
}

void fragment() {
	// ALBEDO = texture(SCREEN_TEX, SCREEN_UV).rgb;
	float depth = (textureLod(DEPTH_TEX, SCREEN_UV, 0.0).r);
	vec4 upos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV*2.0-1.0,depth,1.0);
	vec3 pixel_position = upos.xyz/upos.w;
	ALBEDO.rgb = packFloatInto8BitVec3(((length(pixel_position)))); // packFloat(length(pixel_position));
	ALBEDO.rgb = vec3((log2(length(pixel_position)) + 20.0)/64.0);
	ALBEDO.rgb = vec3(length(pixel_position)/256.0);
	// ALBEDO = vec3(1.0, 1.0, 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
