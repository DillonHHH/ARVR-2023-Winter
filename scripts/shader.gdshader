shader_type spatial;
render_mode unshaded, cull_disabled;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

instance uniform float strength = 0;

void vertex() {
	// POSITION must be set in vertex, this ensures the mesh is hidden and covers the entire screen
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	
	// gets the coordinates of the current pixel being processed
    vec2 uv = SCREEN_UV;
	
	// pixel from original frame
	vec4 original = texture(SCREEN_TEXTURE, uv);
	
    // Calculate the pixel's distance from the center of the screen
    float distance = -length(uv - vec2(.5));
	
	// this sets the pixel we see to the modified pixels from the code above
    ALBEDO = mix(original.rgb, vec3(0,0,0), distance * -strength);
}
