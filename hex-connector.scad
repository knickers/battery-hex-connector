cell_d = 18;
height = 10;
wall = 1;
tolerance = 0.1;

$fs = 2;
root3 = sqrt(3);
hex_d = cell_d + wall;

module tab(tall, tolerance = 0) {
	/* circular? * /
	rotate(-4, [0,0,1])
		translate([(hex_d/root3*2)/2.15, 0, 0])
			#cylinder(d = wall+tolerance, h=tall, $fn=10);
	/**/

	/* triangular? * /
	#polygon()
	/**/

	/* follow contours? */
	difference() {
		cylinder(d=hex_d/root3*2.1, h=tall+2, $fn=6);

		translate([0, 0, -1])
			cylinder(d=cell_d+1, h=tall+4);

		for (a = [0:60:300]) {
			rotate(a, [0,0,1])
				translate([0, cell_d/2-1, -1])
					cube([cell_d, cell_d, tall+4]);
		}
	}
	/**/

	// spiral?
}

module single() {
	difference() {
		cylinder(d=hex_d/root3*2, h=height, $fn=6);

		translate([0, 0, -1])
			cylinder(d=cell_d, h=height+2);

		translate([0, 0, -1])
			tab(height+2);
	}
}

/*
tab(height);
	*/
single();
translate([hex_d*root3/2, -hex_d/2, 0])
	color("red") single();
translate([hex_d*root3/2, hex_d/2, 0])
	color("blue") single();
