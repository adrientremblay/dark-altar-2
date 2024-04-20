shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	object.mesh.material.albedo_color = vec3(1,1,1,1)
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
