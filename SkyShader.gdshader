shader_type sky;

uniform vec3 skyColor : source_color;

void sky() {
	COLOR = skyColor;
}
