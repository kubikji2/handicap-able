// general parameters
$fn = 90;
eps = 0.01;
tol = 0.2;

// libs
use<../lib/round_corners.scad>

// M6 bolt parameters used in this model
// m6_ is used as prefix
// Bolt Diameter
m6_b_d = 6;
// Bolt Head Diameter
m6_bh_d = 9.8;
// Bolt Head Height
//m6_bh_h = 5.75;
m6_bh_h = 6;
// Bolt Thread Length
m6_bt_l = 40;
// Nut Diameter
m6_n_d = 11;
// Nut Lock Height
m6_nl_h = 6;

// WheelChair Interface parameters
// wci_ as prefix
// distance from the cylindric hole to the boder
// NOTE: this value must be meausred
wci_e = 10;
// x dimension
wci_x = 14+wci_e;
// y dimension
// NOTE: measure y dimension, but not necessary
wci_y = 19;
// z dimension
wci_z = 45;

// WheelChair Interface Hole parameters
// wcih_ as prefix
// outer diameter
wcih_do = 14;
// inner diameter
wcih_di = 6.5;
// distance from the bottom to the center of the hole
wcih_dist = 27 + wcih_do/2;
// length of the cylinder with holes
wcih_l = 23;

// wheelchair interface
module wheelchair_interface()
{
    difference()
    {
        // main block with the horizontal cylinder
        union()
        {
            // main geometry
            cube([wci_x, wci_y, wci_z]);
            
            // horizontal cylinder
            translate([ wci_x-wcih_do/2,
                        (wci_y-wcih_l)/2,
                        wcih_dist])
                rotate([-90,0,0])
                    cylinder(d=wcih_do, h=wcih_l);
        }
        
        // hole for the M6 bolt
        translate([ wci_x-wcih_do/2,
                    (wci_y-wcih_l)/2-eps,
                    wcih_dist])
            rotate([-90,0,0])
                cylinder(d=wcih_di, h=wcih_l+2*eps);
    }
}

//wheelchair_interface();

// TODO measure this stuff
// Foot Board parameters
// fb_ as prefix
// x dimension
fb_x = 120;
// y dimension
fb_y = 120;
// z dimension
fb_z = 15;
// thicknes
fb_t = 5;
// wall thickness
fb_wt = 5;
// rounded corners radius
fb_r = 30;

// board to rest foot
module foot_board()
{
    // main shape
    difference()
    {
        // main shape
        round_cube(x=fb_x, y=fb_y, z=fb_z, d=2*fb_r);
        
        // main cut
        translate([fb_wt,fb_wt,-eps])
            round_cube( x=fb_x-2*fb_wt,
                        y=fb_y-2*fb_wt,
                        z=fb_z-fb_t+eps,
                        d=2*fb_r-2*fb_wt);
    }    
    
    // adding support
    x_sups = [  fb_r,
                fb_x-fb_r-fb_wt
             ];
    
    y_sups = [  fb_r,
                fb_y-fb_r-fb_wt
             ];
    
    for (x_sup = x_sups)
    {
        translate([x_sup-eps,fb_wt,0])
            cube([  fb_wt,
                    fb_y-2*fb_wt+2*eps,
                    fb_z-fb_t]);
    }
    
    for (y_sup = y_sups)
    {
        translate([fb_wt-eps,y_sup,0])
            cube([  fb_x-2*fb_wt+2*eps,
                    fb_wt,
                    fb_z-fb_t]);
    }
    
}

foot_board();

// interface parameters
// i_ as prefix
// x dimension
i_x = wci_x+wci_e;
// y dimension
i_y = m6_bt_l + m6_bh_h;
// z dimension
// TODO: determine additional offset
i_z = wci_z + fb_z;


// interfacing part of the foot support
module interface()
{
    difference()
    {
        // main interface block
        // TODO improve shape maybe
        cube([i_x, i_y, i_z]);
        
        // cutting hole for the wheelchair interface
        // - tolerances are in x and in the y
        translate([ -eps,
                    (i_y-wci_y)/2-tol,
                    i_z-wci_z])
            cube([  wci_x+tol+eps,
                    wci_y+2*tol,
                    wci_z+eps]);        
        
        // drilling hole fot bolt and nut
        translate([ wci_x-wcih_do/2,
                    -eps,
                    i_z-wci_z+wcih_dist])
        rotate([-90,0,0])
        {
            // drilling hole for the bolt
            cylinder(d=m6_b_d+tol, h=i_y+2*eps);
            // drilling hole for the bolt head
            cylinder(d=m6_bh_d+tol, h=m6_bh_h);
            // drilling hole for the nut
            rotate([0,0,90])
                translate([0,0,m6_bt_l+2*eps])
                    cylinder(   d=m6_n_d,
                                h=m6_nl_h,
                                $fn=6);
        }
    }
}

interface();
