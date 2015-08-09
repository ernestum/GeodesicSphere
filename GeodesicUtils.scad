use <SketchUtils.scad>
use <MathUtils.scad>
use <Icosahedron.scad>
// Shows the rods between subdivisions of the face of an icosahedron with a given frequency,
// radius and rod diameter
module showSubdivRods(icosafaceID, freq, radius = 10, r = 0.2) {
    p1 = icosaface(icosafaceID, radius)[0];
    p2 = icosaface(icosafaceID, radius)[1];
    p3 = icosaface(icosafaceID, radius)[2];
    for(row = [0:freq-1]) {
        rods(projCarts2sphere( mapSubdivsToTriangle(triangleSubdivCoords(freq, row), p1, p2, p3, freq), radius), r);
        rods(projCarts2sphere( mapSubdivsToTriangle(triangleSubdivCoords(freq, row), p3, p1, p2, freq), radius), r);
        rods(projCarts2sphere( mapSubdivsToTriangle(triangleSubdivCoords(freq, row), p2, p3, p1, freq), radius), r);
    }
}

// Shows the faces of subdivisions of the face of an icosahedron with a given frequency and
// radius
module showSubdivFaces(icosafaceID, freq, radius) {
    p = icosaface(icosafaceID, radius);
    for(i = [0:freq-1]) {
        for(j = [0:freq-i-1]) {
            t1 = projCart2sphere(mapSubdivToTriangle([i, j], p[0], p[1], p[2], freq), radius);
            t2 = projCart2sphere(mapSubdivToTriangle([i+1, j], p[0], p[1], p[2], freq), radius);
            t3 = projCart2sphere(mapSubdivToTriangle([i, j+1], p[0], p[1], p[2], freq), radius);
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
                    icosaface(f, radius)[0],
                    icosaface(f, radius)[1],
                    icosaface(f, radius)[2],
                    freq), radius))) {
                    children(0);
                }
            }
        }
    }
}
