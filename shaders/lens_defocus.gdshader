shader_type canvas_item;
render_mode unshaded;

uniform sampler2D DILATED_SCREEN : hint_screen_texture;
uniform sampler2D SCREEN_TEXTURE;
uniform sampler2D DEPTH_TEXTURE : filter_nearest;
uniform float focalDistance;
uniform vec3 tint;

const float blur_window_size = 3.0;
const float minDist = 20.0;
const float maxDist = 30.0;


void vertex() {
	// Called for every vertex the material is visible on.
}

float unpackFloat(vec3 a) {
	return a.r + a.g * 8.0 + a.b * (8.0*16.0) - 1.0;
}

float unpack8BitVec3IntoFloat(vec3 v) {
   float zeroTo24Bit = (v.x + v.y * 256.0 + v.z * 256.0 * 256.0) * 256.0;
   float zeroToOne = zeroTo24Bit / 256.0 / 256.0 / 256.0;
   return zeroToOne * (512.0);
}

// "debanding" dither

const vec3 noise_magic = vec3(0.06711056, 0.00583715, 52.9829189);
float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(57.461,64.692))) * 57638.3275);
}

void fragment() {
	// Called for every pixel the material is visible on.
	// dilate
	
	// float depth = (pow(2.0, texture(DEPTH_TEXTURE, SCREEN_UV).r * 64.0 - 20.0));
	// float depth = unpack8BitVec3IntoFloat(texture(DEPTH_TEXTURE, SCREEN_UV).rgb);
	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).r * 256.0;
	// float offs = rand(SCREEN_UV);
	// depth += offs * 0.6;
	// depth = texture(DEPTH_TEXTURE, SCREEN_UV).r * 256.0;
	float blur = clamp(smoothstep(minDist, maxDist, abs(depth - focalDistance)), 0.0, 1.0);
	vec4 trueCol = texture(SCREEN_TEXTURE, SCREEN_UV).rgba;
	
	vec3 tintRectified = normalize(tint) * sqrt(3); // length of (1, 1, 1)
	
	if (blur != 0.0) {
	
		const vec2 pxSize = (1.0/vec2(960.0, 540.0));
		float maxBr = -1.0;
		
		vec3 blurCol = vec3(0);
		
		// we merge the two for loops
		
		for (float x = -blur_window_size; x <= blur_window_size; x++) {
			for (float y = -blur_window_size; y <= blur_window_size; y++) {
				vec3 ccol = texture(DILATED_SCREEN, SCREEN_UV + pxSize * vec2(x, y)).rgb;
				blurCol += ccol;
			}
		}
		
		blurCol /= pow(2.0*blur_window_size + 1.0, 2);
		
		// vec3 blurCol = vec3(0);
		

		
		// vec3 dilated = (1.0/3.0) * (1.0*blurCol + 2.0*outc);
		
		
		COLOR.rgb = (mix(trueCol.rgb, blurCol, blur) * tintRectified);
	} else {
		COLOR.rgb = trueCol.rgb * tintRectified;
	}
	// COLOR.rgb = vec3(depth/256.0);
	// COLOR.rgb = vec3(texture(DEPTH_TEXTURE, SCREEN_UV).rgb);
	//COLOR.rgb = vec3((depth >= focalDistance ? 1.0 : 0.0));
	// COLOR.rgb = vec3(blur*200.0);
	// COLOR.rgb = vec3(blur);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
