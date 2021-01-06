// general purpose parameters
eps = 0.01;
$fn = 90;
tol = 0.2;

// XX m suction cup parameters
// '-> sc_t - suction cup thickness
// '-> sc_d - suction cup diameter
// '-> sci_d - suction cup interface narrowed diameter
// '-> sci_t - suction cup interface narrowed thickness
// '-> sci_D - suction cup interface top part diameter
// '-> sci_T - suction cup interface top part thickness
// '-> sci_off - suction cup interace lock offset

// suction cup offset
// '-> 20 mm suction cup
/*
sc_t = 1; // TODO measure
sc_d = 20;
sci_d = 3.6;
sci_t = 1.8;
sci_D = 7;
sci_T = 2+tol;
sci_off = 0.25;
*/

// '-> 30 mm suction cup
/*
sc_t = 1; // TODO measure
sc_d = 30;
sci_d = 4.8;
sci_t = 2.5;
sci_D = 7.8;
sci_T = 1.8+tol;
sci_off = 0.25;
*/

// '-> 40 mm suction cup
///*
sc_t = 1; // TODO measure
sc_d = 40;
sci_d = 8;
sci_t = 2.75;
sci_D = 12.7;
sci_T = 3.75+tol;
sci_off = 0.5;
//*/

// plate holder consits of two part connected by bolt and nut
// '-> upper part has interface to the plate
// '-> middle part connects and reinforce both interfaces
// '-> lower part has interface to the suction cup

// TODO parameters

// plate parameters
// wall thickness
wt = 2;

// plate wall angle
a = 60;
// plate wall thickness
p_t = 5;
// plate hight
p_h = 50;

// plate interface length
pi_l = 5;
// plate interface depth
pi_d = 10;
// plate interface width
pi_w = 10;

// connector parameters
c_d = 10;

// suction cup
// lower part parameters
// - d and h
// upper part parameters
// - D and H

module suction_interface()
{
    _D = 2*wt + sci_D;
    _T = sci_t+sci_T+wt;
    
    difference()
    {
        // main shell
        // '-> hull of lower cylinder and upper 
        hull()
        {
            // block to fit suction cup interface
            translate([-_D/2,-_D/2,0])
                cube([_D,_D,_T]);
            // cylinder TODO
            cylinder(d=sc_d,h=sc_t);
            
        }
        
        // cutting lower suction cup compartement
        translate([0,0,-eps])
            cylinder(d=sci_d, h=sci_t+2*eps);
        // '-> entry hole
        _x = sci_d-2*sci_off;
        _y = sci_D/2+wt;
        translate([-_x/2,0,-eps])
                cube([_x,_y,sci_t+2*eps]);
        // '-> slide in
        hull()
        {
            // wider part
            translate([-_x/2-sci_off,sci_d/2+3*sci_off,-eps])
                cube([_x+2*sci_off,_y,sci_t+2*eps]);
            // more narrow part
            translate([-_x/2,sci_d/2+sci_off,-eps])
                cube([_x,_y,sci_t+2*eps]);
        }
        
        // cutting upper suction cup compartement
        translate([0,0,sci_t])
            cylinder(d=sci_D, h=sci_T);
        
        // '-> hole
        _X = sci_D - 2* sci_off;
        _Y = _y;
        translate([-_X/2,0,sci_t])
            cube([_X,_Y,sci_T]);
        // '-> slide in
        translate([0,0,sci_t])
        hull()
        {
            // wider part
            translate([-_X/2-sci_off,sci_D/2+3*sci_off,0])
                cube([_X+2*sci_off,_y,sci_T]);
            // more narrow part
            translate([-_X/2,sci_D/2+sci_off,0])
                cube([_X,_y,sci_T]);
        }
    }        
}

suction_interface();


module connector(_a=60,_l=p_h)
{
    difference()
    {
        _h = _l - sc_h - sc_H - wt;
        _D = sc_D + 2*wt;
        union()
        {
            // main connector body
            translate([0,(c_d-_D)/2,0])
            {
                cylinder(d=c_d, h=_h);
                translate([-c_d/2,-c_d/2,0])
                    cube([c_d,c_d/2,_h]);
            }
            
            // connecting to the suction cup intergace
            hull()
            {
                // shape of the connector
                translate([0,(c_d-_D)/2,_D-c_d])
                union()
                {
                    cylinder(d=c_d,h=eps);
                    translate([-c_d/2,-c_d/2,0])
                        cube([c_d,c_d/2,eps]);
                }
                // shape of the suction interface
                translate([-_D/2,-_D/2,-eps])
                    cube([_D,_D,eps]);
                
            }
            
            
            
            // plate interface
            _x = pi_w;
            _y = pi_d+wt;
            _z = p_t+3*wt;
            hull()
            {
                // plate-connector interface
                translate([-_x/2,0,_h])
                    rotate([-_a,0,0])
                        cube([_x,_y,_z]);
                // slope
                c_z = cos(_a)*_z;
                s_z = sin(_a)*_y;
                translate([-_x/2,-c_d/2-(_D-c_d)/2,_h-s_z])
                    cube([c_d,eps,c_z+s_z]);
            }
            
        }
        
        // plate interface
        _x = pi_w;
        _y = pi_d+wt;
        _z = p_t+2*wt;
        #translate([-_x/2-eps,0,_h])
            rotate([-_a,0,0])
                translate([0,wt+eps,wt])
                cube([_x+2*eps,pi_d,p_t]);
        
        
        
    }
    
}


module plate_holder(_a=a,_l=p_h)
{
    // lower part e.g. suction cup interfece
    suction_interface(_a=_a,_l=_l);
    
    // adding connector
    translate([0,0,sc_h+sc_H+wt])
        connector(_a=_a);
}

/*

for(i = [50:5:75])
{
    echo(i);
    translate([(i-50)*5,0,0])
        plate_holder(i,p_h);
};

plate_holder(60,p_h);

*/