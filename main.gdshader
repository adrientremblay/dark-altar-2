shader_type canvas_item;
uniform float ghost : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture,filter_linear_mipmap_anisotropic;

uniform float speed : hint_range(0.0, 20.0) = 0.0;
uniform float giggle : hint_range(0.0, 200.0) = 0.0;
uniform float amplitude : hint_range(0.0, 1.0) = 0.0;


void fragment()
{
    vec4 baseTexture = texture(SCREEN_TEXTURE, UV);
    COLOR.r = baseTexture.r;
    COLOR.g = baseTexture.g;
    COLOR.b = baseTexture.b;

    // Centre pour l'effet de fantôme
    vec2 center = vec2(0.5, 0.5);
    vec2 offset = (UV - center) * ghost; // Ajuste le décalage en fonction de 'ghost'
    vec2 ghostUV = center + offset; // Calcule les nouvelles coordonnées UV pour l'effet de fantôme

    // Ajout de l'effet de vibration sur l'effet de fantôme
    vec2 distortion = vec2(ghostUV.x + cos(TIME * speed + (ghostUV.y * giggle)) * amplitude, ghostUV.y);

    // Appliquer l'effet "fantôme" avec les coordonnées UV distordues (vibrantes)
    COLOR += texture(SCREEN_TEXTURE, distortion) * ghost;
}