use <MathUtils.scad>
module makeConnector(angles, labels, labelsize, labeltranslate, labelrotate=0, labelHeight=100000) {
    projection() 
    difference() {
        for(i = [0:len(angles)-1]) {
            echo(labels[i], sum(angles, 0, i));
            rotate([0, 0, -sum(angles, 0, i)]) {
                children(0);
            }
        }
        for(i = [0:len(angles)-1]) {
            echo(labels[i], sum(angles, 0, i));
            rotate([0, 0, -sum(angles, 0, i)]) {
                translate([labeltranslate[0], labeltranslate[1], -labelHeight/2])linear_extrude(labelHeight)  rotate([0, 0, labelrotate]) text(str(labels[i]), labelsize);
            }
        }
    }
}

module make5V_HCBABC_connector(labelsize, labeltranslate, labelrotate=0) {
    makeConnector([65.90224464, 59.51429452, 54.58346084, 54.58346084, 59.51429452, 65.90224464], ["H", "C", "B", "A", "B", "C"], labelsize, labeltranslate, labelrotate) {
        children(0);
    }
}

module make5V_IFDHDF_connector(labelsize, labeltranslate, labelrotate=0) {
    makeConnector([60.461017, 62.94954087, 56.58944213, 56.58944213, 62.94954087, 60.461017], ["I", "F", "D", "H", "D", "F"], labelsize, labeltranslate, labelrotate) {
        children(0);
    }
}

module make5V_DFIF_connector(labelsize, labeltranslate, labelrotate=0) {
    makeConnector([62.94954087, 60.461017, 60.461017, 62.94954087], ["D", "F", "I", "F"], labelsize, labeltranslate, labelrotate) {
        children(0);
    }
}

module make5V_CCDEED_connector(labelsize, labeltranslate, labelrotate=0) {
    makeConnector([62.30453005, 58.90951252, 58.84801223, 62.18042045, 58.84801223, 58.90951252], ["C", "C", "D", "E", "E", "D"], labelsize, labeltranslate, labelrotate) {
        children(0);
    }
}

module make5V_DEED_connector(labelsize, labeltranslate, labelrotate=0) {
    makeConnector([58.84801223, 62.18042045, 58.84801223, 58.90951252], ["D", "E", "E", "D"], labelsize, labeltranslate, labelrotate) {
        children(0);
    }
}

module make5V_GGEFFE_connector(labelsize, labeltranslate, labelrotate=0) {
    makeConnector([60.53957579, 59.69474601, 59.73016166, 60.61060889, 59.73016166, 59.69474601], ["G", "G", "E", "F", "F", "E"], labelsize, labeltranslate, labelrotate) {
        children(0);
    }
}

module make5V_GEFF_connector(labelsize, labeltranslate, labelrotate=0) {
    makeConnector([59.69474601, 59.73016166, 60.61060889, 59.73016166], ["G", "E", "F", "F"], labelsize, labeltranslate, labelrotate) {
        children(0);
    }
}

module make5V_AAAAA_connector(labelsize, labeltranslate, labelrotate=0) {
    makeConnector([72, 72, 72, 72, 72], ["A", "A", "A", "A", "A"], labelsize, labeltranslate, labelrotate) {
        children(0);
    }
}

module makeAll5VConnecotrs(spacing, labelsize, labeltranslate, labelrotate=0) {
    make5V_GEFF_connector(labelsize,  labeltranslate, labelrotate)
       children(0);
    
    translate([spacing, 0, 0]) make5V_DEED_connector(labelsize,  labeltranslate, labelrotate)
       children(0);

    translate([spacing*2, 0, 0]) make5V_DFIF_connector(labelsize,  labeltranslate, labelrotate)
       children(0);

    translate([0, spacing, 0]) make5V_AAAAA_connector(labelsize,  labeltranslate, labelrotate)
       children(0);

    translate([spacing, spacing, 0]) make5V_GGEFFE_connector(labelsize,  labeltranslate, labelrotate)
       children(0);

    translate([spacing*2, spacing, 0]) make5V_CCDEED_connector(labelsize,  labeltranslate, labelrotate)
       children(0);

    translate([0, spacing*2, 0]) make5V_IFDHDF_connector(labelsize,  labeltranslate, labelrotate)
       children(0);

    translate([spacing, spacing*2, 0]) make5V_HCBABC_connector(labelsize,  labeltranslate, labelrotate)
       children(0);
}
module clockConnectorPin(tubeDiam = 32, 
                         tubeInnerDiam = 28.4, 
                         connRad = 80, 
                         connInnerRad = 70, 
                         connThickness = 3, 
                         clipholeDiam = 5) {
    tubeWall = (tubeDiam-tubeInnerDiam)/2;
    difference() {
        translate([-(tubeDiam-2*tubeWall)/2, 0, 0]) cube([tubeDiam-2*tubeWall, connRad, connThickness]);
        linear_extrude() polygon([[0, connInnerRad/2], [-tubeWall, connRad], [tubeWall, connRad]]);
    }
    translate([(tubeDiam-2*tubeWall)/2, connRad-clipholeDiam, 0]) cube([tubeWall, clipholeDiam, connThickness]);
    translate([-(tubeDiam-2*tubeWall)/2-tubeWall, connRad-clipholeDiam, 0]) cube([tubeWall, clipholeDiam, connThickness]);
}

module pressfitConnectorPin(tubeDiam, tubeInnerDiam, connDiam, conInnerDiam, taper) {
    linear_extrude(1) polygon([[tubeInnerDiam/2, conInnerDiam/2], [(tubeInnerDiam/2)*taper, connDiam/2], [-(tubeInnerDiam/2)*taper, connDiam/2], [-tubeInnerDiam/2, conInnerDiam/2]]); //Stump cone
    linear_extrude(1) polygon([
        [(tubeDiam/2)*1.1, 0],
        [(tubeDiam/2)*1.1, (conInnerDiam/2)*1.1], 
        [(tubeDiam/2), (conInnerDiam/2)*1.3], 
        [(tubeDiam/2), (conInnerDiam/2)], 
        [-(tubeDiam/2), (conInnerDiam/2)],
        [-(tubeDiam/2), (conInnerDiam/2)*1.1],
        [-(tubeDiam/2)*1.1, (conInnerDiam/2)*1.1],
        [-(tubeDiam/2)*1.1, 0],
    ]);
}

    pressfitConnectorPin(32, 28.4, 200, 100, 0.8);

//make5V_DFIF_connector(10,  [-5, 20], 0) {
//    pressfitConnectorPin(32, 28.4, 200, 100, 0.8);
//}

//makeConnector([30, 45, 30, 45], ["A", "B", "C", "D", "E"], 0.5, 8, 1) {
//    translate([5, 0, 0]) cube([10, 2, 0.1], center=true);
//}