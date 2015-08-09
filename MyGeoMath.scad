//=== Math helpers

//Golden Ratio
PHI = (sqrt(5) + 1)/2;
    
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
    
    
//=== Drawing helpers

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

//=== Icosahedron

// The cartesian coordinates of an icosahedron. Unfortunately it does not stand
// upright
icosapoints = [ [0, 1, PHI], //
                [PHI, 0, 1],
                [1, PHI, 0],
                [0, 1, -PHI], //
                [-PHI, 0, 1],
                [1,-PHI, 0],
                [0, -1, PHI], //
                [PHI, 0, -1],
                [-1, PHI, 0],
                [0, -1, -PHI], //
                [-PHI, 0, -1],
                [-1, -PHI, 0],
               ];

// Computes the cartesian coordinates of a point of an icosahedron wiht a given
// radius (be default 1). The id must be between 0 and 11 because an icosahedron
// has only 12 points.
function icosapoint(id, r=1) = projCart2sphere(icosapoints[id], r);

// Pairs of point indices that describe the lines of an icosahedron
icosalines = [ [0, 1], [1, 2], [2, 0], //Upper triangle
               [0, 4], [0, 6], [0, 8], //Downward connections of 0
               [1, 5], [1, 6], [1, 7], //Downward connections of 1
               [2, 3], [2, 7], [2, 8], //Downward connections of 2
               [3, 8], [8, 4], [4, 6], [6, 5], [5, 7], [7, 3], //Zigzag equator
               [9, 3], [9, 5], [9, 7], //Upward connections of 9
               [10, 3], [10, 4], [10, 8], //Upward connections of 10
               [11, 4], [11, 5], [11, 6], //Upward connections of 11
               [9, 10], [10, 11], [11, 9], //Lower triangle 
             ];

// Triples of point indices that describe the 20 faces of an icosahedron
icosafaces = [ [0, 1, 2], //Top
               [0, 1, 6], //Adjacent to top
               [0, 2, 8], // ..
               [1, 2, 7], // ..
               [1, 5, 6],
               [1, 5, 7],
               [0, 4, 6],
               [0, 4, 8],
               [2, 3, 8],
               [2, 3, 7],
               [9, 10, 11], //Bottom
               [9, 10, 3], //Adjacent to bottom
               [9, 11, 5], // ..
               [10, 11, 4], // ..
               [11, 6, 4],
               [11, 6, 5],
               [10, 8, 4],
               [10, 8, 3],
               [9, 7, 3],
               [9, 7, 5]
              ];

//=== Triangle subdivision

// Computes the coordinates of a subdividing point of a triangle    
function mapSubdivToTriangle(subdivCoord, p1, p2, p3, freq) = 
    let(dirI = (p2 - p1)/freq, 
        dirJ = (p3 - p1)/freq)
            p1 + dirI*subdivCoord[0] + dirJ*subdivCoord[1];

// Maps a list of subdivision coordinates to their actual coordinates when mapped to a triangle
function mapSubdivsToTriangle(subdivCoords, p1, p2, p3, freq) = 
    let(radius = cart2pol(p1)[2], 
        dirI = (p2 - p1)/freq, 
        dirJ = (p3 - p1)/freq) 
            [for (subdivCoord = subdivCoords) p1 + dirI*subdivCoord[0] + dirJ*subdivCoord[1]];

// Generates subdivision coordinates for a triangle
// for a given subdivision frequency and row (see documentation/examples to understand
// this)            
function triangleSubdivCoords(freq, row=0) = [ for (i = [0:freq-row]) [i, row]];
    
//=== Geodesics stuff

// Shows the rods between subdivisions of the face of an icosahedron with a given frequency,
// radius and rod diameter
module showSubdivRods(icosafaceID, freq, radius = 10, r = 0.2) {
    p1 = icosapoint(icosafaces[icosafaceID][0], radius);
    p2 = icosapoint(icosafaces[icosafaceID][1], radius);
    p3 = icosapoint(icosafaces[icosafaceID][2], radius);    
    for(row = [0:freq-1]) {
        rods(projCarts2sphere( mapSubdivsToTriangle(triangleSubdivCoords(freq, row), p1, p2, p3, freq), radius), r);
        rods(projCarts2sphere( mapSubdivsToTriangle(triangleSubdivCoords(freq, row), p3, p1, p2, freq), radius), r);
        rods(projCarts2sphere( mapSubdivsToTriangle(triangleSubdivCoords(freq, row), p2, p3, p1, freq), radius), r);
    }
}

// Shows the faces of subdivisions of the face of an icosahedron with a given frequency and
// radius 
module showSubdivFaces(icosafaceID, freq, radius) {
    p1 = icosapoint(icosafaces[icosafaceID][0], radius);
    p2 = icosapoint(icosafaces[icosafaceID][1], radius);
    p3 = icosapoint(icosafaces[icosafaceID][2], radius); 
    for(i = [0:freq-1]) {
        for(j = [0:freq-i-1]) {
            t1 = projCart2sphere(mapSubdivToTriangle([i, j], p1, p2, p3, freq), radius);
            t2 = projCart2sphere(mapSubdivToTriangle([i+1, j], p1, p2, p3, freq), radius);
            t3 = projCart2sphere(mapSubdivToTriangle([i, j+1], p1, p2, p3, freq), radius);
            polyhedron( points = [t1, t2, t3], faces = [[0, 1, 2]]);
        }
    }        
}

// Shows the rods of a geodesic sphere with a given radius, frequency and rod diameter
module geodesicSphereRods(radius, freq, roddiam=2) {
    for (f = [0:len(icosafaces)-1] ) 
        showSubdivRods(f, freq, radius, roddiam);
}

// Places its children on the nodes of a geodesic sphere with a given frequency and radius
// The children are also rotated in such a way that they point outward.
// Could be a good tool if you want to design connectors or place your designed connectors
module placeOnGeodesicSphereNodes(radius, freq) {
    for (f = [0:len(icosafaces)-1] ) {
        for(row = [0:freq-1]) {
            for(subdiv = triangleSubdivCoords(freq, row)) {
                shpericalPlace(cart2pol(projCart2sphere( mapSubdivToTriangle(subdiv, 
                    icosapoint(icosafaces[f][0], radius), 
                    icosapoint(icosafaces[f][1], radius), 
                    icosapoint(icosafaces[f][2], radius), freq), radius))) {
                    children(0);        
                }
            }
        }
    }
}

//===Actual User Code

radius = 400;

//difference() {
//rotate([31.5, 0, 0])
//        geodesicSphereRods(radius, 5, 2);
//rotate([180, 0, 0]) translate([-radius, -radius, 45]) cube([radius*2, radius*2, radius*2]);
//}

//difference() {
//rotate([31.5, 0, 0])
//    difference() {
//        placeOnGeodesicSphereNodes(radius, 5) cylinder(d=15, h=0.3);
//        difference() {
//            geodesicSphereRods(radius, 5, 2);
//            placeOnGeodesicSphereNodes(radius - 2.5, 5) cylinder(d=10, h=10);
//        }
//    }
//rotate([180, 0, 0]) translate([-radius, -radius, 45]) cube([radius*2, radius*2, radius*2]);
//}

//Computes the Dihedral angle between to adjacent faces of a dome
//The Two faces are specified by the two subdivision coordinates where the faces touch
module geoAngleMeasurement1(upperSubdivCoord, lowerSubdivCoord, freq, radius=10) {
    
    icosaP1 = icosapoint(icosafaces[0][0], radius);
    icosaP2 = icosapoint(icosafaces[0][1], radius);
    icosaP3 = icosapoint(icosafaces[0][2], radius);
    
    %showSubdivRods(0, freq, radius, 0.05);
    
    p1 = projCart2sphere(mapSubdivToTriangle(lowerSubdivCoord - [0, 1], icosaP1, icosaP2, icosaP3, freq), radius);
    p2 = projCart2sphere(mapSubdivToTriangle(upperSubdivCoord, icosaP1, icosaP2, icosaP3, freq), radius);
    p3 = projCart2sphere(mapSubdivToTriangle(lowerSubdivCoord, icosaP1, icosaP2, icosaP3, freq), radius);
    p4 = projCart2sphere(mapSubdivToTriangle(upperSubdivCoord + [0, 1], icosaP1, icosaP2, icosaP3, freq), radius);
    
    dihedralAngleMeasurement(p1, p2, p3, p4);
}

//Computes the dihedral angle between two adjacent faces of a dome,
//that are not on the same icosaface
module geoAngleMeasurement2(row, freq, radius = 10) {
    icosaP1 = icosapoint(icosafaces[0][0], radius);
    icosaP2 = icosapoint(icosafaces[0][1], radius);
    icosaP3 = icosapoint(icosafaces[0][2], radius);
    icosaP4 = icosapoint(icosafaces[1][2], radius);

    p1 = projCart2sphere(mapSubdivToTriangle([1, 1], icosaP1, icosaP2, icosaP3, freq), radius);
    p2 = projCart2sphere(mapSubdivToTriangle([1, 0], icosaP1, icosaP2, icosaP3, freq), radius);
    p3 = projCart2sphere(mapSubdivToTriangle([2, 0], icosaP1, icosaP2, icosaP3, freq), radius);
    p4 = projCart2sphere(mapSubdivToTriangle([1, 1], icosaP1, icosaP2, icosaP4, freq), radius);
    
    %showSubdivRods(0, freq, radius, 0.05);
    %showSubdivRods(1, freq, radius, 0.05);

    dihedralAngleMeasurement(p1, p2, p3, p4);

}

//Computes and shows the angles at a connection hub specified by its subdiv coord
//Only works on coordinates "inside" the triangle, not on the corners or edges
module geoAngleMeasurement3(subdivCoord, freq, radius=10) {
    
    icosaP1 = icosapoint(icosafaces[1][0], radius);
    icosaP2 = icosapoint(icosafaces[1][1], radius);
    icosaP3 = icosapoint(icosafaces[1][2], radius);
    
    %showSubdivRods(1, freq, radius, 0.05);
    
    //Coordinate of the point we want to measure around 
    thisCoord = projCart2sphere(mapSubdivToTriangle(subdivCoord, icosaP1, icosaP2, icosaP3, freq), radius);
    
    //list of neighbor coordinates in counter clockwise order
    neighborCoords = [ 
        projCart2sphere(mapSubdivToTriangle(subdivCoord + [-1, 0], icosaP1, icosaP2, icosaP3, freq), radius),
        projCart2sphere(mapSubdivToTriangle(subdivCoord + [-1, 1], icosaP1, icosaP2, icosaP3, freq), radius),
        projCart2sphere(mapSubdivToTriangle(subdivCoord + [ 0, 1], icosaP1, icosaP2, icosaP3, freq), radius),
        projCart2sphere(mapSubdivToTriangle(subdivCoord + [ 1, 0], icosaP1, icosaP2, icosaP3, freq), radius),
        projCart2sphere(mapSubdivToTriangle(subdivCoord + [1, -1], icosaP1, icosaP2, icosaP3, freq), radius),
        projCart2sphere(mapSubdivToTriangle(subdivCoord + [0, -1], icosaP1, icosaP2, icosaP3, freq), radius)
    ];

    for(i = [0:len(neighborCoords)-1]) {
        translate(thisCoord)
            vectorAngleMeasurement(neighborCoords[i] - thisCoord, neighborCoords[(i+1)%len(neighborCoords)] - thisCoord);
    }
    
}

module geoAngleMeasurement4(row, freq, radius = 10) {
    icosaP1 = icosapoint(icosafaces[0][0], radius);
    icosaP2 = icosapoint(icosafaces[0][1], radius);
    icosaP3 = icosapoint(icosafaces[0][2], radius);
    icosaP4 = icosapoint(icosafaces[1][2], radius);
    
    %showSubdivRods(0, freq, radius, 0.05);
    %showSubdivRods(1, freq, radius, 0.05);
    
//    translate(icosaP1) label("1");
//    translate(icosaP2) label("2");
//    translate(icosaP3) label("3");
//    translate(icosaP4) label("4");
    
    thisCoord = projCart2sphere(mapSubdivToTriangle([row, 0], icosaP1, icosaP2, icosaP3, freq), radius);
    
    neighborCoords = [ 
        projCart2sphere(mapSubdivToTriangle([row+1, 0], icosaP1, icosaP2, icosaP3, freq), radius),
        projCart2sphere(mapSubdivToTriangle([row, 1], icosaP1, icosaP2, icosaP3, freq), radius),
        projCart2sphere(mapSubdivToTriangle([row-1, 1], icosaP1, icosaP2, icosaP3, freq), radius),
        projCart2sphere(mapSubdivToTriangle([row-1, 0], icosaP1, icosaP2, icosaP3, freq), radius),
        projCart2sphere(mapSubdivToTriangle([row-1, 1], icosaP1, icosaP2, icosaP4, freq), radius),
        projCart2sphere(mapSubdivToTriangle([row, 1], icosaP1, icosaP2, icosaP4, freq), radius),
    ];
    
    for(i = [0:len(neighborCoords)-1]) {
        translate(thisCoord)
            vectorAngleMeasurement(neighborCoords[i] - thisCoord, neighborCoords[(i+1)%len(neighborCoords)] - thisCoord);
    }
}

module dihedralAngleMeasurement(p1, p2, p3, p4) {
    rod(p1, p2);
    #rod(p2, p3);
    rod(p3, p4);
    b1 = p2 - p1;
    b2 = p3 - p2;
    b3 = p4 - p3;
    angle = atan2(cross(cross(b1, b2), cross(b2, b3)) * b2/norm(b2), cross(b1, b2) * cross(b2, b3));
    echo("Angle:", 180+angle);
}

module vectorAngleMeasurement(v1, v2) {
    rod([0, 0, 0], v1);
    rod([0, 0, 0], v2);
    angle = atan2(norm(cross(v1,v2)), v1 * v2);
    labelPos = (v1 + v2)*0.7;
    translate(labelPos) label(str(angle), norm(v1-v2)/8);
}

geoAngleMeasurement4(1, 5);
//geoAngleMeasurement1([1, 0], [0, 1], 3);
//geoAngleMeasurement2(2,4);

