// generic parameters
$fn = 90;
eps = 0.01;
tol = 0.2;

// M6 parameters
// M6 bolt and nuts are used
m6_d = 6;
// nut diameter
m6_n_d = 11;
// nut height
//m6_n_h = 4;


// interface parameters
// i_ as prefix
// y dimension
i_y = 51;
// hole center distances
i_dist = 19.25+6;
// x dimension
i_x = i_y-i_dist;
// z dimension
// NOTE: this parameters can change
i_z = 4.75;

// nut hole paramters
// nh_ as prefix
// height
nh_h = 4;
// wall thickness
nh_wt = 3;


// nut hole
module nut_hole(tlr = 2)
{
    poss =  [ [0,-tlr/2,0],
              [0,tlr/2,0]
            ];
    
    difference()
    {
        // conical walls
        hull()
        for (pos = poss)
        {
            translate(pos)
            cylinder(   d1 = m6_n_d+4*nh_wt,
                        d2 = m6_n_d+2*nh_wt,
                        h = nh_h);
        }
        
        // hole for the M6 bolt
        hull()
        for (pos = poss)
        {
            translate(pos)
            translate([0,0,-eps])
            rotate([0,0,90])
            cylinder(   d = m6_n_d,
                        h = nh_h+2*eps,
                        $fn = 6);
        }
    }
}

// arm support interface part
module interface()
{
    hole_tolerance = 2;
    poss = [    [i_x/2,i_x/2,0],
                [i_x/2,i_x/2+i_dist,0]
           ];
    
    // main block with holes
    difference()
    {
        // main block
        cube([i_x, i_y, i_z]);
        
        // bolt holes 
        for(pos = poss)
        {
            translate(pos)
                translate([0,0,-eps])
                    cylinder(h=i_z+2*eps,d=m6_d); 
        }

        // debug information
        fd = 0.5;
        fs = 3;
        translate([fs,i_y/2,i_z-fd+eps])
            linear_extrude(fd)
                text(   text=str(hole_tolerance),
                        size=fs,
                        halign="center",
                        valign="center");
        translate([i_x-fs,i_y/2,i_z-fd+eps])
            linear_extrude(fd)
                text(   text=str(i_dist),
                        size=fs,
                        halign="center",
                        valign="center");
    }
    
    // adding the nut walls
    for(pos = poss)
    {
        translate(pos)
            translate([0,0,i_z])
                nut_hole(tlr=hole_tolerance);
    }

}

interface();