use <MathUtils.scad>

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
