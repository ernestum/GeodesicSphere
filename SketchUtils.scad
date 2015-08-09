// Draws a rod between two points with a given thickness (by default 0.1)
// The rod has two spherical endcaps which are centered around the endpoints
// Therefore it is actually a bit wider
module rod(from, to, thickness = 0.1) {
    hull() {
            translate(from) sphere(thickness);
            translate(to) sphere(thickness);
    }
}

// Draws multiple rods between the list of coordinates with a given thickness
module rods(coords, thickness = 0.1) {
    for (i = [0:len(coords)-2]) {
        rod(coords[i], coords[i+1], thickness);
    }
}

// Draws a label with 'l' with a given size and color such that it always
// faces the direction of the viewport
module label(l, size = 1, c="black") {
    color(c) rotate($vpr) text(str(l), size);
}

rod([0, 0, 0], [100, 100, 100], 7);

rods([for (i = [0:90:360*3]) [cos(i) * 70, sin(i) * 40, i-360*1.5]], 3);

translate([100, 100, 100]) label("This is an auto adjusting label!", 50);
    
