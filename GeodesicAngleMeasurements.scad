use <AngleMeasurements.scad>;
include <GeodesicUtils.scad>; //TODO: why does it need an include here?
use <Icosahedron.scad>;
use <MathUtils.scad>;
use <TriangleSubdivision.scad>;
use <SketchUtils.scad>;
use <TriangleSubdivision.scad>;

//Computes the Dihedral angle between to adjacent faces of a dome
//The Two faces are specified by the two subdivision coordinates where the faces touch
module geoAngleMeasurement1(upperSubdivCoord, lowerSubdivCoord, freq, radius=10) {

    icosaP = icosaface(0, radius);

    %showSubdivRods(0, freq, radius, 0.05);

    p1 = projCart2sphere(mapSubdivToTriangle(lowerSubdivCoord - [0, 1], icosaP[0], icosaP[1], icosaP[2], freq), radius);
    p2 = projCart2sphere(mapSubdivToTriangle(upperSubdivCoord, icosaP[0], icosaP[1], icosaP[2], freq), radius);
    p3 = projCart2sphere(mapSubdivToTriangle(lowerSubdivCoord, icosaP[0], icosaP[1], icosaP[2], freq), radius);
    p4 = projCart2sphere(mapSubdivToTriangle(upperSubdivCoord + [0, 1], icosaP[0], icosaP[1], icosaP[2], freq), radius);

    dihedralAngleMeasurement(p1, p2, p3, p4);
}

//Computes the dihedral angle between two adjacent faces of a dome,
//that are not on the same icosaface
module geoAngleMeasurement2(row, freq, radius = 10) {

    icosaP1 = icosaface(0, radius)[0];
    icosaP2 = icosaface(0, radius)[1];
    icosaP3 = icosaface(0, radius)[2];
    icosaP4 = icosaface(1, radius)[2];

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

    icosaP1 = icosaface(1, radius)[0];
    icosaP2 = icosaface(1, radius)[1];
    icosaP3 = icosaface(1, radius)[2];

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
    icosaP1 = icosaface(0, radius)[0];
    icosaP2 = icosaface(0, radius)[1];
    icosaP3 = icosaface(0, radius)[2];
    icosaP4 = icosaface(1, radius)[2];

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

//Lineup of the different kinds angles that we can measure TODO: more comments on this
translate([-30, 0, 0]) {
    geoAngleMeasurement1([1, 0], [0, 1], 3);
    translate([20, 0, 0]) geoAngleMeasurement2(2,4);
    translate([40, 0, 0]) geoAngleMeasurement3([2, 2], 5);
    translate([60, 0, 0]) geoAngleMeasurement4(1, 5);
}

