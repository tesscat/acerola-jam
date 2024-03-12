shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D tex;

uniform float visibility;

float rand(vec2 co)
{
    return fract(sin(dot(co.xy ,vec2(57.461,64.692))) * 57638.3275);
}


// splits x into 0, 1/bands, 2/bands .. (bands-1)/bands
float band(float bands, float x) {
	return floor(x*(bands - 0.0001))/bands;
}

void fragment() {
	if (visibility <= 0.1) {
		ALBEDO.rgb = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	} else {
		float noise = round(rand(vec2(TIME * band(72.0*5.0, SCREEN_UV.x), TIME * band(48.0*5.0, SCREEN_UV.y))));
		ALBEDO.rgb = mix(
			mix(texture(SCREEN_TEXTURE, SCREEN_UV).rgb, vec3(noise), visibility), texture(tex, UV*16.0).rgb, 
			clamp(visibility*1.5, 0, 1));
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
