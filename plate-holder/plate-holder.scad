// general purpose parameters
eps = 0.01;
$fn = 90;
tol = 0.2;

////////////////////////////
// suction cup parameters //
////////////////////////////
// '-> sc_t - suction cup thickness
// '-> sc_d - suction cup diameter
// '-> sci_d - suction cup interface narrowed diameter
// '-> sci_t - suction cup interface narrowed thickness
// '-> sci_D - suction cup interface top part diameter
// '-> sci_T - suction cup interface top part thickness
// '-> sci_off - suction cup interace lock offset

// suction cup offset parameters
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

// '-> 30 mm suction cup parameters
/*
sc_t = 1; // TODO measure
sc_d = 30;
sci_d = 4.8;
sci_t = 2.5;
sci_D = 7.8;
sci_T = 1.8+tol;
sci_off = 0.25;
*/

// '-> 40 mm suction cup parameters
///*
sc_t = 1.5+tol; // TODO measure
sc_d = 41;
sci_d = 8;
sci_t = 2.75;
sci_D = 12.7;
sci_T = 3.75+tol;
sci_off = 0.5;
//*/

// plate holder consits of two part connected by bolt and nut
// '-> upper part has interface to the plate
//     '-> consits of used bolt and nuts
//     '-> and thickness of the middle component
// '-> middle part connects and reinforce both interfaces
//     '-> affected by used suction cup
//     '-> TODO identify them, not needed now  
// '-> lower part has interface to the suction cup
//     '-> all parameters needed are asociated with the suction cup interface

// plate parameters
// wall thickness
wt = 2;

// plate wall angle
a = 60;
// plate wall thickness
p_t = 5;
// plate hight
// '-> also point where joint is
p_h = 50+9;

// plate interface depth
pi_d = 10;
// plate interface width
pi_w = 10;

// joint parameters
// M3x10 choosen for first experiment
// '-> nd - nut diameter
// '-> nt - nut thickness
// '-> bd - bolt diameter
// '-> bhd - bolt head diameter
// '-> bht - bolt head thickness
// '-> btl - bolt thread length
// '-> bl - bolt (total) length including thread and head
nd = 6.2;
nt = 2.4;
bd = 3; // M3
bhd = 5.1;
bht = 1.8;
btl = 10; //x10
bl = btl+bht;

// joint dimensions
// '-> make is same as total lengt of the bolt
j_x = bl;
j_y = (bl-tol)/2;
j_z = j_x;

// plate interace parameters
// '-> pi_cd - plate interface cut depth
// '-> pi_ch - plate interface cut height
// '-> pi_x, pi_y, pi_z - plate interface dimensions
pi_cd = 10;
pi_ch = p_t; // same as the plate wall thickness
pi_x = j_x;
pi_y = j_x;
pi_z = pi_cd+5;

// connector parameters
// '-> connector diameter
c_d = j_x;

module suction_interface()
{
    _D = 2*wt + sci_D;
    _T = sc_t+sci_t+sci_T+wt;
    
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
            cylinder(d=sc_d+2*wt,h=sc_t+wt);
            
        }
        
        // cutting suction cup disc compartement
        translate([0,0,-eps])
            cylinder(d=sc_d,h=sc_t+eps);
        
        // adding hole into suction cup disc borderline
        translate([-sci_D/2,0,-eps])
            cube([sci_D,sc_d,sc_t]);

        // moving suction cup interface up
        translate([0,0,sc_t])
        {
            // cutting lower suction cup compartement
            // '-> hole for interace
            translate([0,0,-eps])
                cylinder(d=sci_d, h=sci_t+2*eps);
            
            // '-> entry hole
            _x = sci_d-2*sci_off;
            _y = sc_d;
            translate([-_x/2,0,-eps])
                    cube([_x,_y,sci_t+2*eps]);
            
            // '-> slide in lock
            hull()
            {
                // wider part
                translate([-_x/2-sci_off,sci_d/2+3*sci_off,-sc_t-eps])
                    cube([_x+2*sci_off,_y,sci_t+2*eps+sc_t]);
                // more narrow part
                translate([-_x/2,sci_d/2+sci_off,-eps])
                    cube([_x,_y,sci_t+2*eps]);
            }
            
            // cutting upper suction cup compartement
            // '-> hole for interace
            translate([0,0,sci_t])
                cylinder(d=sci_D, h=sci_T);
            
            // '-> hole
            _X = sci_D - 2* sci_off;
            _Y = _y;
            translate([-_X/2,0,sci_t])
                cube([_X,_Y,sci_T]);
            
            // '-> slide in lock
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
}


//suction_interface();

module joint_shape()
{
    // rounded connecting
    translate([0,0,j_x/2+tol])
        rotate([90,0,0])
            cylinder(d=j_x,h=j_y);
    // connecting part
    translate([-j_x/2,-j_y,0])
        cube([j_x,j_y,j_z/2+tol]);
    
    
}


module lower_joint()
{
    translate([0,-j_y-tol/2,0])
    rotate([0,0,180])
    difference()
    {
        // basic shape
        joint_shape();
        
        // translate into center
        translate([0,eps,j_z/2+tol])
        {
            // hole for the bolt
            rotate([90,0,0])
                cylinder(d=bd+tol,h=j_y+2*eps);
            
            // hole for the bolt head
            rotate([90,0,0])
                cylinder(d=bhd+tol,h=bht);
        }
        
    }
}

//lower_joint();

module upper_joint()
{   
    translate([0,j_y+tol/2,0])
    difference()
    {
        // basic shape
        joint_shape();
        
        // translate to the center
        translate([0,eps,j_z/2+tol])
        {
            // hole for the bolt
            rotate([90,0,0])
                cylinder(d=bd+tol,h=j_y+2*eps);
            
            // hole for nut
            rotate([90,0,0])
                cylinder(d=nd,h=nt+tol,$fn=6);
        }
    }
}


module plate_interface()
{
    difference()
    {
        // main cubic shape
        union()
        {
            // main cubic shape
            cube([pi_x, pi_y, pi_z-j_x/2]);
            
            // rounded are on the top
            translate([pi_x/2,pi_x,pi_z-pi_x/2])
                rotate([90,0,0])
                    cylinder(h=pi_y,d=pi_x);
            
            // connector to the joint
            translate([0,pi_y-j_y,0])
                cube([pi_x, j_y, pi_z]);
            
        }
        // cut for plate wall
        translate([(pi_x-pi_ch)/2,-eps,-eps])
            cube([pi_ch,pi_y+2*eps,pi_d+eps-pi_ch/2]);
            
        // rounded border for better reinforcement
        translate([pi_x/2,pi_y+eps,pi_d-pi_ch/2])
            rotate([90,0,0])
                cylinder(d=pi_ch,h=pi_y+2*eps);
        
        
    }
}

module upper_piece()
{
    // plate interface
    translate([-pi_x/2,-pi_x/2,-pi_z])
        plate_interface();
    
    // and upper joint
    translate([0,j_y+tol,0])
        rotate([0,0,180])
            upper_joint();
    
}

module connector()
{
    difference()
    {
        _h = p_h - sci_t - sci_T - wt - sc_t - j_y - tol;
        _D = sci_D + 2*wt;
        union()
        {
            // main connector body
            translate([-c_d/2,-c_d/2,0])
            {
                // connector to the joint
                cube([c_d,j_y,_h]);
                
                // reinforcement
                hull()
                {
                    // lower full cube
                    cube([c_d,c_d,_D-c_d]);           
                    
                    // connecting to the joint
                    cube([c_d,j_y,_h-c_d]);
                }
            }
            
            // connecting to the suction cup intergace
            hull()
            {
                // shape of the connector
                translate([0,0,_D-c_d])
                {
                    translate([-c_d/2,-c_d/2,0])
                        cube([c_d,c_d,eps]);
                }
                // shape of the suction interface
                translate([-_D/2,-_D/2,-eps])
                    cube([_D,_D,eps]);
            }
            
            // adding upper joint
            /*
            translate([0,0,_h])
                rotate([0,0,180])
                    lower_joint();
            */
            translate([0,0,_h])
                lower_joint();
         }
    }
    
}

module lower_piece()
{
    suction_interface();
    translate([0,0,sci_t+sci_T+wt+sc_t])
        connector();
}

lower_piece();

//upper_piece();