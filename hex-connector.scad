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

part = "Three";  // [Tab, One, Three]

shape = "Circular"; // [Circular, Triangular, Contoured, Spiral]

root3 = sqrt(3);
hex_d = cell_d + wall * 2; // Hex diameter at the FLATS
hex_r = hex_d / 2;         // Hex radius at the FLATS
hex_p = hex_d / root3 * 2; // Hex diameter at the PEAKS

if (part == "Tab") {
	tab(height, "inside");
	tab(height, "outside");
}
else if (part == "One") {
	single();
}
else if (part == "Three") {
	r = hex_d*root3/2;
	translate([-hex_p/2, 0, 0])
		rotate(-60, [0,0,1])
			color("green") single();
	translate([hex_p/4, -hex_r, 0])
		color("red")
			single();
	translate([hex_p/4, hex_r, 0])
		color("blue")
			single();
}

module tabs(where="inside") {
	translate([0, 0, where == "inside" ? -1 : 0])
		for (a = [0:60:300])
			rotate(a, [0,0,1]) {
				if (where == "inside") {
					tab(height+2, where);
				}
				else if (where == "outside") {
					translate([0, hex_d, 0])
						rotate(-120, [0,0,1])
							tab(height, where);
				}
			}
}

module tab(tall, where="inside") {
	T = where == "inside" ? tolerance : -tolerance;

	if (shape == "Circular") {
		D = wall * 1.4;
		rotate(60-4, [0,0,1])
			translate([hex_p/2-D*0.6, 0, 0])
				cylinder(d=D+T, h=tall, $fs=$fs/6);
	}
	else if (shape == "Triangular") {
	}
	else if (shape == "Contoured") {
		or = hex_r + T/2;
		ir = hex_r - T/2;
		end_a = asin((or-wall) / ir); // a = asin(opp/hyp)
		start = 30;
		steps = get_fragments(ir, end_a - start); // 4;
		angle = (end_a - start) / (steps-1);
		linear_extrude(tall)
			polygon([
				[
					cos(start)*ir*1.01,
					sin(start)*ir*1.01
				],
				for (i = [0:steps-1]) [
					cos(start + angle*i)*ir,
					sin(start + angle*i)*ir
				],
				[or*.65, or-wall]   // Q1
			]);
	}
	else if (shape == "Spiral") {
	}
}

module single() {
	difference() {
		union() {
			cylinder(d=hex_p-tolerance, h=height, $fn=6);
			tabs("outside");
		}

		translate([0, 0, -1])
			cylinder(d=cell_d, h=height+2);

		tabs("inside");
	}
}

function get_fragments(radius, angle=360) = ceil(
	max(
		min(
			angle / $fa,
			radius*2*PI*(angle/360) / $fs
		),
		5
	)
);
