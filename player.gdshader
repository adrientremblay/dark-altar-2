shader_type canvas_item;

uniform lowp sampler2D screen_texture : hint_screen_texture, filter_nearest_mipmap, repeat_enable;
uniform lowp float alpha : hint_range(0.0, 1.0);
uniform lowp float scale : hint_range(0.0, 2.0);

uniform lowp float red_shift;
uniform lowp float blue_shift;
uniform lowp float green_shift;

uniform lowp float red_mult = 1;

void fragment() {
	vec2 uvs = SCREEN_UV * scale;
	vec4 final_texture  = texture(screen_texture, uvs);

	float r = texture(screen_texture, uvs + vec2(SCREEN_PIXEL_SIZE*red_shift), 0.0).r * red_mult;
	float g = texture(screen_texture, uvs + vec2(SCREEN_PIXEL_SIZE*green_shift), 0.0).g;
	float b = texture(screen_texture, uvs + vec2(SCREEN_PIXEL_SIZE*blue_shift), 0.0).b;

	COLOR = vec4(r, g, b, alpha);
}