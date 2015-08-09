function rad2deg(rad) = 180/PI * rad;

function deg2rad(deg) = PI/180 * deg;

// Converts polar coordinates to cartesian coordinates
function pol2cart(s) = [
	s[2]*sin(s[1])*cos(s[0]),
	s[2]*sin(s[1])*sin(s[0]),
	s[2]*cos(s[1])
	];

// Converts cartesian coordinates to polar coordinates
function cart2pol(c) = [
    atan2(c[1],c[0]),
    atan2(norm([c[0], c[1]]), c[2]),
    norm(c)
	];

// Projects spherical coordinates to a circle of a given radius (default 1)
// This basically just overwrites the radius of the spherical coordinate
function projPol2sphere(s, r = 1) = [s[0], s[1], r];

// Projects a cartesian coordinate to a sphere with a given radius (by default 1)
function projCart2sphere(c, r = 1) = pol2cart(projPol2sphere(cart2pol
(c), r));

// Projects a list of cartesian coordinates to a sphere with a given radius
function projCarts2sphere(carts, r = 1) = [for (cart = carts) pol2cart(projPol2sphere(cart2pol
(cart), r))];

// Places its children at some polar coordinates and rotates in such a way, that it looks
// away from the center of the sphere. Usefull if you want to place something ontop of
// a sphere
module shpericalPlace(s) {
    rotate([0, s[1], s[0]])
    translate([0, 0, s[2]]) {
        children([0:$children-1]);
    }
}

use <SketchUtils.scad>

// Demo for projCart2sphere
// Here we first generate 100 random points, then we draw rods between those points
// and their projections to a sphere
randPoints = [for (i = [0:100]) rands(-100, 100, 3)];
for(point = randPoints) {
    rod(point, projCart2sphere(point, 50), 1);
}


// Demo for sphericalPlace
// Here we place some funny shape onto a sphere
module funnyShape() {
    translate([0, 0, 20]) cube([10, 10, 40],center=true);
    translate([0, 0, 40]) sphere(10);
}
shpericalPlace([30, -70, 50]) funnyShape();
shpericalPlace([30, 70, 50]) funnyShape();
shpericalPlace([-30, 180, 50]) funnyShape();