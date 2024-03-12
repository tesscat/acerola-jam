shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;


// https://www.shadertoy.com/view/tsfXWj
const mat3 rgb2yiq = mat3(vec3(0.299, 0.596, 0.211),
                        vec3(0.587, -0.274, -0.523),
                        vec3(0.114, -0.322, 0.312));

const mat3 yiq2rgb = mat3(vec3(1, 1, 1),
                        vec3(0.956, -0.272, -1.106),
                        vec3(0.621, -0.647, 1.703));

const float noiseMax = 0.03;

float rand(vec2 co)
{
    return fract(sin(dot(co.xy ,vec2(57.461,64.692))) * 57638.3275);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec2 half_px_offs = 0.75 * SCREEN_PIXEL_SIZE;
	vec3 sample0 = rgb2yiq * texture(SCREEN_TEXTURE, SCREEN_UV + vec2(half_px_offs.x, 0)).xyz;
	vec3 sample1 = rgb2yiq * texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-half_px_offs.x, 0)).xyz;
	vec3 sample2 = rgb2yiq * texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0, half_px_offs.y)).xyz;
	vec3 sample3 = rgb2yiq * texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0, -half_px_offs.y)).xyz;
	vec3 sum = sample0 + sample1 + sample2 + sample3;
	// dither us
	sum.x += mix(-noiseMax, noiseMax, rand(SCREEN_UV));
	
	sum = 0.25 * (1.0/20.0) * round(20.0*(sum));
	COLOR.xyz = yiq2rgb * sum;
	// dither a little to break up the bands
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
