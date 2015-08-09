include <Constants.scad>
use <MathUtils.scad>
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

// Computes the cartesian coordinates of a point of an icosahedron wiht a given
// radius (default 1). The id must be between 0 and 11 because an icosahedron
// has only 12 points.
function icosapoint(id, r=1) = projCart2sphere(icosapoints[id], r);

// Computes the pair of cartesian coordinates of a line of an icosahedron
// based in its index and a radius (default 1). Since an icosahedron has 30
// lines, the index needs to be between 0 and 29
function icosaline(id, r=1) = [for (pid = icosalines[id]) icosapoint(pid, r)];

// Computes the triple of cartesian coordinates for a face of an icosahedron
// based on its index and a radius. Since an icosahedron has 20 faces, the index
// needs to be between 0 and 19
function icosaface(id, r=1) = [for (pid = icosafaces[id]) icosapoint(pid, r) ];
    
use <SketchUtils.scad>

//shows a wireframe of an icosahedron with radius 50
for(line = [for (i=[0:len(icosalines)-1]) icosaline(i, 50)]) 
    rod(line[0], line[1], 0.3);


//shows the indices of the points
for(i = [0:11]) 
    translate(icosapoint(i, 50)) label(i,8);
    
//shows the indices of the lines in red
for(i = [0:len(icosalines)-1]) 
    translate((icosaline(i, 50)[0]+icosaline(i, 50)[1])/2) label(i, 4, "red");

//shows the indices of the faces in blue
for(i = [0:len(icosafaces)-1])
    translate((icosaface(i, 50)[0] + icosaface(i, 50)[1] + icosaface(i, 50)[2])/3)
        label(i, 4, "blue");
