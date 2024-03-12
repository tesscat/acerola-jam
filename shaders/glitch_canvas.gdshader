shader_type canvas_item;

uniform float rSeed;
uniform float invIntensity;
uniform float warpStrength;
uniform vec2 warpInp;
uniform float glitchOverlay;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

vec2 random(vec2 uv) {
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(57.461,64.692))) * 57638.3275);
}

// https://godotshaders.com/snippet/2d-noise/
float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) + 0.5;
}


void vertex() {
	// Called for every vertex the material is visible on.
}
// splits x into 0, 1/bands, 2/bands .. (bands-1)/bands
float band(float bands, float x) {
	return floor(x*(bands - 0.0001))/bands;
}

float warp(float warpFact, float myPos) {
	return pow((myPos + warpFact - 0.5), 4);
}

void fragment() {
	if (invIntensity > 0.9) {
		COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
	} else {
		// agressive upscaling (nearest-neighbour) then posterize (round agressive)
		// sample at 16x9 or 48x27 or same aspect ratio
		float xp = band(4.5, SCREEN_UV.x);
		float yp = band(3.0, SCREEN_UV.y);

		// sample the noise +  band it
		float myNoise = noise(4.0*(vec2(xp, yp) + random(vec2(rSeed, 0.0))));
		myNoise = band(5.0, myNoise);
		
		// calculate the warpiness
		// how aligned are we with the warp?
		vec2 warpOut = vec2(0.0);
		if (length(warpInp) != 0.0) {
			vec2 w = normalize(warpInp);
			float newX = warp(w.x, UV.x) * warpInp.x;
			float newY = warp(w.y, UV.y) * warpInp.y;
			warpOut = vec2(newX, newY);
		}
		vec2 uvFinal = SCREEN_UV + warpStrength*warpOut;
		if (uvFinal.x < 0.0 || uvFinal.y < 0.0 || uvFinal .x >= 1.0 || uvFinal.y >= 1.0) {
			COLOR.rgb = vec3(0);
		} else {
			COLOR = texture(SCREEN_TEXTURE, uvFinal);
		}
		
		if (myNoise > invIntensity) {
			vec3 highlight = vec3(rand(vec2(TIME, SCREEN_UV.y)), rand(vec2(SCREEN_UV.y, TIME)), rand(vec2(TIME, TIME)));
			// sample noise again but at higher def + random y bit
			float thresh = noise(random(vec2(TIME, yp)) + vec2(UV.x, 0.0));
			if (thresh > 0.5) {
				COLOR.rgb = mix(COLOR.rgb, highlight * 0.6, glitchOverlay);
			} else {
				COLOR.rgb = mix(COLOR.rgb, vec3(0.0), glitchOverlay);
			}
		}
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
