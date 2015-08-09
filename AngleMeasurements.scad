use <SketchUtils.scad>
module dihedralAngleMeasurement(p1, p2, p3, p4) {
    rod(p1, p2);
    #rod(p2, p3);
    rod(p3, p4);
    b1 = p2 - p1;
    b2 = p3 - p2;
    b3 = p4 - p3;
    angle = atan2(cross(cross(b1, b2), cross(b2, b3)) * b2/norm(b2), cross(b1, b2) * cross(b2, b3));
    translate((p2 + p3)/2) label(180+angle);
}

module vectorAngleMeasurement(v1, v2) {
    rod([0, 0, 0], v1);
    rod([0, 0, 0], v2);
    angle = atan2(norm(cross(v1,v2)), v1 * v2);
    labelPos = (v1 + v2)*0.7;
    translate(labelPos) label(str(angle), norm(v1-v2)/8);
}




