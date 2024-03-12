shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;


// https://www.shadertoy.com/view/tsfXWj
const mat3 rgb2yiq = mat3(vec3(0.299, 0.596, 0.211),
                        vec3(0.587, -0.274, -0.523),
                        vec3(0.114, -0.322, 0.312));

const mat3 yiq2rgb = mat3(vec3(1, 1, 1),
                        vec3(0.956, -0.272, -1.106),
                        vec3(0.621, -0.647, 1.703));

float rand(vec2 co)
{
    return fract(sin(dot(co.xy ,vec2(57.461,64.692))) * 57638.3275);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	vec3 col = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	if (length(col) == 0.0) {col = vec3(0.01, 0.01, 0.01);}
	if (length(col) < 0.2) {
		float nl = pow(length(col), 2)/1.2 + 0.1;
		col *= nl/length(col);
	}
	
	COLOR.xyz = col;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
