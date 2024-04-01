shader_type spatial;

instance uniform float scale = 0;

void vertex(){
	VERTEX.y += sin(VERTEX.x * scale) + cos(VERTEX.z * scale);
}