// general parameters
$fn = 90;
eps = 0.01;
tol = 0.2;

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

wheelchair_interface();

// interfacing part of the foot support
module interface()
{
    
}

