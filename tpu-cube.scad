CUBE_SIZE=11;
CUBE_GAP=1;
CURVE_RADIUS=1;
HINGE_THICKNESS=1;
HINGE_OFFSET=0.15+HINGE_THICKNESS/2;
HINGE_NOTCH=0.4;
HINGE_WIDTH=CUBE_SIZE-CURVE_RADIUS*2;

module roundedcube(size = [1, 1, 1], center = false, radius = 0.5) {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate = (center == false) ?
		[radius, radius, radius] :
		[
			radius - (size[0] / 2),
			radius - (size[1] / 2),
			radius - (size[2] / 2)
	];

	translate(v = translate)
	minkowski() {
		cube(size = [
			size[0] - (radius * 2),
			size[1] - (radius * 2),
			size[2] - (radius * 2)
		]);
		sphere(r = radius);
	}
}

// centered on the given position, oriented along the X axis by default
module hinge() {
    difference() {
        cube([HINGE_WIDTH, HINGE_WIDTH, HINGE_THICKNESS], true);
        translate([0, 0, -HINGE_NOTCH])
            scale([4, 1, 1])
                rotate([90, 270, 0])
                    cylinder(h=HINGE_WIDTH,r=HINGE_NOTCH, center=true, $fn=3);
    }
}

for(x = [0 : 3]) {
    for(y = [0: 1]) {
        translate([x * (CUBE_SIZE + CUBE_GAP), y * (CUBE_SIZE + CUBE_GAP), 0])
            roundedcube(CUBE_SIZE, false, CURVE_RADIUS);
    }
}

translate([CUBE_SIZE + CUBE_GAP / 2, CUBE_SIZE / 2, HINGE_OFFSET])
    hinge();
translate([CUBE_SIZE + CUBE_GAP / 2, CUBE_SIZE + CUBE_GAP + CUBE_SIZE / 2, HINGE_OFFSET])
    hinge();
translate([CUBE_SIZE * 3 + CUBE_GAP * 2.5, CUBE_SIZE / 2, HINGE_OFFSET])
    hinge();
translate([CUBE_SIZE * 3 + CUBE_GAP * 2.5, CUBE_SIZE + CUBE_GAP + CUBE_SIZE / 2, HINGE_OFFSET])
    hinge();

translate([CUBE_SIZE * 2 + CUBE_GAP * 1.5, HINGE_OFFSET, CUBE_SIZE / 2])
    rotate([-90, 0, 0])
        hinge();
translate([CUBE_SIZE * 2 + CUBE_GAP * 1.5, CUBE_SIZE * 2 + CUBE_GAP - HINGE_OFFSET, CUBE_SIZE / 2])
    rotate([90, 0, 0])
        hinge();

translate([CUBE_SIZE / 2, CUBE_SIZE + CUBE_GAP / 2, CUBE_SIZE - HINGE_OFFSET])
    rotate([0, 180, -90])
        hinge();
translate([CUBE_SIZE * 3.5 + CUBE_GAP * 3, CUBE_SIZE + CUBE_GAP / 2, CUBE_SIZE - HINGE_OFFSET])
    rotate([0, 180, -90])
        hinge();
