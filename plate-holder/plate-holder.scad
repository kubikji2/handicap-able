// general purpose parameters
eps = 0.01;
$fn = 90;

// plate parameters
// wall thickness
wt = 2;


// suction cup
// lower part parameters
// - d and h
// upper part parameters
// - D and H

// suction cup offset
sc_off = 0.5;
// '-> 2 mm suction cup
///*
sc_diam = 20;
sc_d = 3.5;
sc_h = 2;
sc_D = 7;
sc_H = 2;
//*/

// '-> 3 mm suction cup
/*
sc_diam = 30;
sc_d = 4.6;
sc_h = 2.5;
sc_D = 7.5;
sc_H = 1.8;
*/

// '-> 4 mm suction cup
/*
sc_diam = 40;
sc_d = 8;
sc_h = 2.75;
sc_D = 12.7;
sc_H = 3.75;
*/

module suction_interface()
{
    _D = 2*wt + sc_D;
    _H = sc_h+sc_H+wt;
    
    difference()
    {
        //main shell
        cylinder(d=_D, h=_H);
        
        // cutting lower suction cup compartement
        translate([0,0,-eps])
            cylinder(d=sc_d, h=sc_h+2*eps);
        // '-> entry hole
        _x = sc_d-2*sc_off;
        _y = sc_D/2+wt;
        translate([-_x/2,0,-eps])
                cube([_x,_y,sc_h+2*eps]);
        // '-> slide in
        hull()
        {
            // wider part
            translate([-_x/2-sc_off,sc_d/2+3*sc_off,-eps])
                cube([_x+2*sc_off,_y,sc_h+2*eps]);
            // more narrow part
            translate([-_x/2,sc_d/2+sc_off,-eps])
                cube([_x,_y,sc_h+2*eps]);
        }
        
        // cutting upper suction cup compartement
        translate([0,0,sc_h])
            cylinder(d=sc_D, h=sc_H);
        
        // '-> hole
        _X = sc_D - 2* sc_off;
        _Y = _y;
        translate([-_X/2,0,sc_h])
            cube([_X,_Y,sc_H]);
        // '-> slide in
        translate([0,0,sc_h])
        hull()
        {
            // wider part
            translate([-_X/2-sc_off,sc_d/2+3*sc_off,0])
                cube([_X+2*sc_off,_y,sc_h]);
            // more narrow part
            translate([-_X/2,sc_d/2+sc_off,0])
                cube([_X,_y,sc_h]);
        }
    }
    
}

suction_interface();