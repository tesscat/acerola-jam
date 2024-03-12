shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE;
uniform vec3 tint;

void vertex() {
	// Called for every vertex the material is visible on.
}

// somewhat based off https://godotshaders.com/shader/2d-radial-distortion-fisheye-barrel/

const float distortion = 1.4;
const float aspect = 1.0;

vec2 distort(vec2 myCoords) {
	float d = length(myCoords);
	float z = sqrt(distortion + d*d*(0.1));
	float r = atan(d, z);
	float phi = atan(myCoords.y, myCoords.x);
	return vec2(r*cos(phi)*(1.0/aspect) + 0.5, r*sin(phi) + 0.5);
}

void fragment() {
	vec2 uv = SCREEN_UV * 2.0 - vec2(1.0, 1.0); // move (0.5, 0.5) to (0, 0)
	uv.x *= aspect;
	uv = distort(uv/2.0);
	COLOR.rgb = texture(SCREEN_TEXTURE, uv).rgb * tint;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
