shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D tex;

uniform bool isEnabled;

float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(57.461,64.692))) * 57638.3275);
}

// splits x into 0, 1/bands, 2/bands .. (bands-1)/bands
float band(float bands, float x) {
	return floor(x*(bands - 0.0001))/bands;
}

void fragment() {
	if (isEnabled) {
		ALBEDO.rgb = texture(tex, UV*16.0).rgb;
	} else {
		float time = floor(TIME * 15.0 + 5.0);
		float noise = round(rand(vec2(time * band(72.0*2.0, SCREEN_UV.x), time * band(48.0*2.0, SCREEN_UV.y))));
		ALBEDO.rgb = vec3(noise) * 0.1 + texture(SCREEN_TEXTURE, SCREEN_UV).rgb * 0.9 + texture(tex, UV*16.0).rgb * 0.0;
	}
}
