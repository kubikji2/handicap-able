// general parameters
$fn = 90;
eps = 0.01;
tol = 0.2;

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
// x dimension
wci_x = 14+10;
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

// interface parameters
// i_ as prefix
// x parameters
i_x = wci_x;
// y parameters
i_y = m6_bt_l + m6_bh_h;
// z parameters
// TODO: determine additional offset
i_z = wci_z + 10;

// interfacing part of the foot support
module interface()
{
    difference()
    {
        // main interface block
        cube([i_x, i_y, i_z]);
        
        // cutting hole for the wheelchair interface
        translate([ -eps,
                    (i_y-wci_y)/2-tol,
                    i_z-wci_z])
            cube([  wci_x+2*eps,
                    wci_y+2*tol,
                    wci_z+eps]);        
        
        // drilling hole fot bolt and nut
        translate([ i_x-wcih_do/2,
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
