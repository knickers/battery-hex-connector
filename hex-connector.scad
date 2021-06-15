// Space between parts
tolerance = 0.1; // [0:0.05:0.5]

// Wall Thickness
wall = 1;        // [0.5:0.5:5]

// Cell Diameter
cell_d = 18;     // [10:1:60]
cell_r = cell_d / 2;

// Connector Height
height = 10;     // [1:1:50]

// Resolution
$fs = 2;         // [1:High, 2:Medium, 4:Low]
$fa = 0.01 + 0;

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
