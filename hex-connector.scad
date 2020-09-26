cell_d = 18;
height = 10;

$fs = 2;
root3 = sqrt(3);
hex_d = cell_d + 1;

module tab(tolerance = 0) {
	// circular?
	// triangular?
	// follow contours?
	// spiral?
}

module single() {
	difference() {
		cylinder(d=hex_d/root3*2, h=height, $fn=6);

		translate([0, 0, -1])
			cylinder(d=cell_d, h=height+2);
	}
}

single();
translate([hex_d*root3/2, -hex_d/2, 0])
	color("red") single();
translate([hex_d*root3/2, hex_d/2, 0])
	color("blue") single();
