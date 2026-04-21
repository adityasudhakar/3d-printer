$fn = 96;

// Toggle the default view.
show_assembly = true;
show_print_layout = false;

// Candy and printer assumptions.
candy_d = 15;
fit_clearance = 0.20;          // Friction-fit clearance per side for the cover plug.
rotating_clearance = 0.30;     // Radial running clearance around the roller.

// Overall envelope.
overall_w = 50;
overall_h = 200;

// Major parts.
base_t = 22;
cover_t = 8;
body_h = overall_h - base_t - cover_t;

// Body.
side_t = 4;
back_t = 3;
front_glue_land = 0;
body_w = overall_w;
roller_d = 24;
roller_r = roller_d / 2;
roller_gap_wall = 0.60;        // Gap from roller OD to back wall / future acrylic.
channel_d = roller_d + 2 * roller_gap_wall;
body_d = back_t + channel_d + front_glue_land;
inner_w = body_w - 2 * side_t;
acrylic_plane_y = body_d;

// Roller and scoop.
roller_handle_extension = 14;
roller_len = body_w + 2 * roller_handle_extension;
roller_hole_d = roller_d + 2 * rotating_clearance;
scoop_d = 16.5;
scoop_len = inner_w - 1.0;
scoop_center_lift = 4.0;       // Offsets the scoop upward to avoid a paper-thin shell.

// Vertical placement.
body_z = base_t;
roller_z = 150;
roller_y = body_d / 2;

// Slides.
slide_count = 5;
slide_t = 3;
slide_depth = channel_d - 2.0;
slide_margin = 8;
slide_run = inner_w - slide_margin;
slide_angle = 22;
slide_drop = slide_run * sin(slide_angle);
roller_to_slide_gap = 15;
slide_step_z = 21;
top_slide_high_z = (roller_z - roller_r - body_z) - roller_to_slide_gap - slide_t;
slide_anchor_z = [for (i = [0 : slide_count - 1]) top_slide_high_z - i * slide_step_z];

// Fifth slide discharge point. The last slide is the left slide, so candy exits near the right side.
last_slide_end_x = (side_t - 0.4) + slide_run * cos(slide_angle);

// Base.
base_front_margin = 30;
base_d = body_d + base_front_margin;

// Cover plug.
cover_plug_h = 12;
cover_plug_w = inner_w - 2 * fit_clearance;
cover_plug_d = channel_d - 2 * fit_clearance;

module base_plate() {
    color([0.96, 0.64, 0.05])
    difference() {
        cube([overall_w, base_d, base_t]);
        translate([trough_x, trough_y, trough_z])
            trough_wedge_origin();
    }
}

module cover_plate() {
    color([0.96, 0.64, 0.05])
    union() {
        cube([overall_w, body_d, cover_t]);

        // One-piece friction plug. 0.20 mm per side is a sane FDM starting point.
        translate([(overall_w - cover_plug_w) / 2,
                   back_t + fit_clearance,
                   -cover_plug_h])
            cube([cover_plug_w, cover_plug_d, cover_plug_h]);
    }
}

module left_slide(anchor_z) {
    translate([side_t - 0.4, back_t + 1.0, anchor_z])
        rotate([0, slide_angle, 0])
        cube([slide_run, slide_depth, slide_t]);
}

module right_slide(anchor_z) {
    translate([body_w - side_t + 0.4, back_t + 1.0, anchor_z])
        rotate([0, -slide_angle, 0])
        translate([-slide_run, 0, 0])
        cube([slide_run, slide_depth, slide_t]);
}

module body_part() {
    color([0.74, 0.74, 0.76])
    difference() {
        union() {
            cube([body_w, back_t, body_h]);
            cube([side_t, body_d, body_h]);
            translate([body_w - side_t, 0, 0])
                cube([side_t, body_d, body_h]);

            for (i = [0 : slide_count - 1]) {
                if (i % 2 == 0) {
                    left_slide(slide_anchor_z[i]);
                } else {
                    right_slide(slide_anchor_z[i]);
                }
            }
        }

        // Circular through-holes that the roller snaps into.
        translate([-1, roller_y, roller_z - body_z])
            rotate([0, 90, 0])
            cylinder(d = roller_hole_d, h = body_w + 2, center = false);
    }
}

module roller_part() {
    color([0.95, 0.68, 0.08])
    difference() {
        rotate([0, 90, 0])
            cylinder(d = roller_d, h = roller_len, center = true);

        // Single scoop sized for one 15 mm candy.
        translate([0, 0, scoop_center_lift])
            rotate([0, 90, 0])
            cylinder(d = scoop_d, h = scoop_len, center = true);
    }
}

module assembly_view() {
    translate([0, 0, 0])
        base_plate();

    translate([0, 0, body_z])
        body_part();

    translate([body_w / 2, roller_y, roller_z])
        roller_part();

    translate([0, 0, overall_h - cover_t])
        cover_plate();
}

module print_layout_view(spacing = 10) {
    // Base
    translate([0, 0, 0])
        base_plate();

    // Body printed on the back wall.
    translate([overall_w + spacing, 0, 0])
        rotate([90, 0, 0])
        body_part();

    // Cover
    translate([overall_w + body_h + 2 * spacing, 0, 0])
        cover_plate();

    // Roller
    translate([overall_w + body_h + overall_w + 3 * spacing, roller_r + 2, 0])
        rotate([90, 0, 0])
        roller_part();
}

if (show_assembly) {
    assembly_view();
}

if (show_print_layout) {
    print_layout_view();
}
