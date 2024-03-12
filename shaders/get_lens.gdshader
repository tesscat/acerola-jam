shader_type spatial;

uniform float distortion_size = 0.3;
uniform sampler2D glass;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

void fragment() {
	float d = 1.0 - texture(glass, UV).x;
	ALBEDO = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(d * distortion_size, 0.0)).rgb;
}

void vertex() {
	
}