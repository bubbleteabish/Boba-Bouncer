shader_type canvas_item;
uniform float onoff;
uniform float squish_amount = 3;
uniform float squish_speed = 10.0;

void vertex() {
	// Called for every vertex the material is visible on.
    // Calculate a squish factor based on time and vertex y-position
	if (onoff == 1.0) {
    	float squish = sin(TIME * squish_speed + VERTEX.y) * squish_amount;    
	    // Apply squish to the y-coordinate
	    VERTEX.y += squish;
	}
	else {
		//float i = squish_amount;
		//while (i > 1.0){
			//float squish = sin(TIME * squish_speed - VERTEX.y) * i;
			//VERTEX.y -= i;
			//i -= 1.0;
		float squish = sin(TIME * squish_speed + VERTEX.y) * squish_amount;    
	    // Apply squish to the y-coordinate
	    VERTEX.y += squish;
		//}
		
	}
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
