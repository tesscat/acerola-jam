shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float colourSplitIntensity;
uniform float noiseIntensity_u;
uniform float barsIntensity;

void vertex() {
	// Called for every vertex the material is visible on.
}

float rand(vec2 co)
{
    return fract(sin(dot(co.xy ,vec2(57.461,64.692))) * 57638.3275);
}

const float shiftMax = 0.01;
const float rShift = 0.002;
const float gShift = -0.002;
const float halfBarSize = 0.07;

const float tm1 = 4.0;
const float tm2 = 2.0;
const float tm3 = 3.0;
const float barsTotal = 300.0;
const float noiseIntensity = 0.003;

float hzBar(float hpos, float ypos, float offs) {
	float e0 = (hpos - halfBarSize);
	float e1 = (hpos + halfBarSize);
	float x = smoothstep(e0, hpos, ypos) * offs;
	x -= smoothstep(hpos, e1, ypos) * offs;
	return x;
}

void fragment() {
	vec2 uv = SCREEN_UV;
	float r1 = rand(vec2(ceil(TIME/tm1), 0));
	float r2 = rand(vec2(ceil(TIME/tm2), 0));
	float r3 = rand(vec2(ceil(TIME/tm3), 0));
	float xoffs = hzBar(r1 - (r1)*fract(TIME/tm1), uv.y, shiftMax);
	xoffs += hzBar((r2 - r2*fract(TIME/tm2)), uv.y, shiftMax);
	xoffs += hzBar((r3 - r3*fract(TIME/tm3)), uv.y, shiftMax);
	// uv.x += xoffs;
	
	// uv.y = floor(uv.y*barsTotal)/barsTotal;
	
	for (float i = 0.0; i < 0.72; i += 0.13) {
		float d = mod(TIME * i, 1.6);
		float o = sin(1.0 - tan(TIME * 0.24 * i));
		o*=shiftMax;
		uv.x += hzBar(1.0 - d, uv.y, o) * barsIntensity;
	}
	
	float snapRes = floor(uv.y*barsTotal)/barsTotal;
	float noise = rand(vec2(TIME * 0.001, 3.0 * snapRes));
	uv.x += (noise - 0.5) * noiseIntensity * noiseIntensity_u;
	
	// uv.x += shiftMax * sin(TIME + TAU*uv.y) + (rand(vec2(TIME * 0.0001, uv.y)) - 0.5)*0.01;
	// Called for every pixel the material is visible on.
	float vrand2 = rand(vec2((TIME + 2.4) * 0.001, 0.0));
	float st = sin(TIME + 5.0 * vrand2);
	st = st * colourSplitIntensity;
	COLOR.r = texture(SCREEN_TEXTURE, vec2(uv.x + (rShift * st), uv.y)).r;
	COLOR.g = texture(SCREEN_TEXTURE, vec2(uv.x + (gShift * st), uv.y)).g;
	COLOR.b = texture(SCREEN_TEXTURE, vec2(uv.x, uv.y)).b;
	
	// COLOR.rgb = yiq2rgb * (0.01 * round(100.0*(rgb2yiq*COLOR.rgb)));
}
//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
