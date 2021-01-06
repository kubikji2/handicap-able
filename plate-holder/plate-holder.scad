// general purpose parameters
eps = 0.01;
$fn = 90;
tol = 0.2;

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

// suction cup offset
// '-> 2 mm suction cup
/*
sc_off = 0.25;
sc_diam = 20;
sc_d = 3.6;
sc_h = 1.8;
sc_D = 7;
sc_H = 2+tol;
*/

// '-> 3 mm suction cup
/*
sc_off = 0.25;
sc_diam = 30;
sc_d = 4.8;
sc_h = 2.5;
sc_D = 7.8;
sc_H = 1.8+tol;
*/

// '-> 4 mm suction cup
///*
sc_off = 0.5;
sc_diam = 40;
sc_d = 8;
sc_h = 2.75;
sc_D = 12.7;
sc_H = 3.75+tol;
//*/

module suction_interface(_a=0,_l=0)
{
    _D = 2*wt + sc_D;
    _H = sc_h+sc_H+wt;
    
    difference()
    {
        // TODO possiblz change orientation
        //main shell
        //cylinder(d=_D, h=_H);
        translate([-_D/2,-_D/2,0])
            cube([_D,_D,_H]);
        
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
            translate([-_X/2-sc_off,sc_D/2+3*sc_off,0])
                cube([_X+2*sc_off,_y,sc_H]);
            // more narrow part
            translate([-_X/2,sc_D/2+sc_off,0])
                cube([_X,_y,sc_H]);
        }
        
        // debug print
        f_s = 5;
        f_d = 0.5;
        translate([_D/2+eps-f_d,0,_H/2])
        rotate([0,90,0])
        rotate([0,0,90])  
            linear_extrude(f_d)
                text(str("a:",_a),
                    font="Consolas:style=Regular",size=f_s,
                    valign="center", halign="center");
        
        translate([-_D/2-eps+f_d,0,_H/2])
        rotate([0,-90,0])
        rotate([0,0,270])  
            linear_extrude(f_d)
                text(str("h:",_l),
                    font="Consolas:style=Regular",size=f_s,
                    valign="center", halign="center");

    }
        
}


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

for(i = [50:5:75])
{
    echo(i);
    translate([(i-50)*5,0,0])
        plate_holder(i,p_h);
};

plate_holder(60,p_h);

