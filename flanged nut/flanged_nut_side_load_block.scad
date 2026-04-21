//// Side-load practice block for a flanged plastic nut.
//
// Based on the nut dimensions provided:
// - flange diameter: 34 mm
// - flange thickness: 3 mm
// - hex width across flats: 24 mm
// - hex width tip-to-tip: 28 mm
// - hex height above flange: 10 mm
// - threaded shaft outer diameter: 12 mm

$fn = 96;

// Measured or user-provided dimensions
flange_diameter = 34.0;
hex_flat_width = 24.0;
hex_point_width = 28.0;
bolt_diameter = 12.0;
nut_total_height = 13.0;
flange_thickness = 3.0;

// Print-fit allowances
fit_clearance = 0.6;
bolt_clearance = 0.8;

// Block wall thicknesses
side_wall = 4.0;
end_wall = 5.0;
top_cover = 2.5;
bottom_cover = 2.5;

block_x = flange_diameter + end_wall + 2;
block_y = flange_diameter + 2 * side_wall;
block_z = nut_total_height + top_cover + bottom_cover;

nut_center_x = block_x / 2;
nut_center_y = block_y / 2;
nut_base_z = bottom_cover;
hex_height = nut_total_height - flange_thickness;

module hex_prism(flat_width, height) {
    cylinder(h = height, d = flat_width / cos(30), $fn = 6);
}

module flanged_nut_side_load_block() {
    difference() {
        cube([block_x, block_y, block_z], center = false);

        // Vertical bolt hole through the full block.
        translate([nut_center_x, nut_center_y, -0.1])
            cylinder(h = block_z + 0.2, d = bolt_diameter + bolt_clearance);

        // Lower circular flange pocket.
        translate([nut_center_x, nut_center_y, nut_base_z])
            cylinder(h = flange_thickness + 0.2, d = flange_diameter + fit_clearance);

        // Upper hex pocket that stops the nut from rotating.
        translate([nut_center_x, nut_center_y, nut_base_z + flange_thickness])
            rotate([0, 0, 30])
                hex_prism(hex_flat_width + fit_clearance, hex_height + 0.2);

        // Side entry slot so the nut can slide in from the left.
        translate([-0.1,
                   nut_center_y - (flange_diameter + fit_clearance) / 2,
                   nut_base_z])
            cube([nut_center_x + 0.1,
                  flange_diameter + fit_clearance,
                  nut_total_height + 0.2], center = false);
    }
}

flanged_nut_side_load_block();
