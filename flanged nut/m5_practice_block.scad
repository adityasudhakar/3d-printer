// Simple thread-practice blocks for learning how bolts, clearance holes,
// and captive nuts work together.
//
// Default hardware:
// - M5 hex nut
// - M5 bolt
//
// Print with the large flat face on the bed.

$fn = 64;

block_x = 16;
block_y = 16;
block_z = 9;

bolt_diameter = 5.5;     // Slight clearance for an M5 bolt
nut_flat_width = 8.4;    // Typical M5 nut width across flats + clearance
nut_thickness = 4.4;     // Typical M5 nut thickness + clearance
nut_cover = 2.5;         // Plastic wall left above the nut pocket

module hex_prism(flat_width, height) {
    cylinder(h = height, d = flat_width / cos(30), $fn = 6);
}

module practice_block() {
    difference() {
        cube([block_x, block_y, block_z], center = false);

        // Through-hole for the bolt.
        translate([block_x / 2, block_y / 2, -0.1])
            cylinder(h = block_z + 0.2, d = bolt_diameter);

        // Captive nut pocket on the underside.
        translate([block_x / 2, block_y / 2, block_z - nut_thickness - nut_cover])
            rotate([0, 0, 30])
                hex_prism(nut_flat_width, nut_thickness + 0.2);
    }
}

module side_load_practice_block() {
    difference() {
        cube([block_x, block_y, block_z], center = false);

        // Through-hole for the bolt.
        translate([block_x / 2, block_y / 2, -0.1])
            cylinder(h = block_z + 0.2, d = bolt_diameter);

        // Captive nut pocket.
        translate([block_x / 2, block_y / 2, block_z - nut_thickness - nut_cover])
            rotate([0, 0, 30])
                hex_prism(nut_flat_width, nut_thickness + 0.2);

        // Side slot so the nut can slide into the pocket.
        translate([-0.1, (block_y - nut_flat_width) / 2, block_z - nut_thickness - nut_cover])
            cube([block_x / 2 + 0.1, nut_flat_width, nut_thickness + 0.2], center = false);
    }
}

spacing = 12;

//practice_block();
translate([block_x + spacing, 0, 0])
    side_load_practice_block();
