use<round_corners.scad>;

eps = 0.01;
tol = 0.3;
$fn = 45;

// rattle parameters
r_x = 40;
r_y = 30;
r_z = 20;
r_r = 15;
wt = 1.5;

// rattle base parameters
rb_d = 2;
rb_t = 2*rb_d;

/*
module bare_rattle()
{
    difference()
    {
        scale([r_x, r_y, r_z])
            sphere(r=1);
        scale([r_x-wt, r_y-wt, r_z-wt])
            sphere(r=1);
    }
}
*/

module bare_rattle()
{
    difference()
    {
        union()
        {
            round_cube(x=r_x,y=r_y,z=r_z/2,d=r_r);
            sphere_cube(x=r_x,y=r_y,z=r_z,d=r_r);
        }
        
        translate([wt,wt,wt])
        union()
        {
            round_cube(x=r_x-2*wt,y=r_y-2*wt,z=r_z/2,d=r_r-2*wt);
            sphere_cube(x=r_x-2*wt,y=r_y-2*wt,z=r_z-2*wt,d=r_r-2*wt);
        }
    }
}

module rattle()
{
    // rattle
        bare_rattle();
    
    points = [  [-rb_d,r_r/2+rb_d/2,-eps],
                [-rb_d,r_r/2+2.5*rb_d,-eps],
                [-rb_d,r_y-r_r/2-rb_d/2,-eps],
                [-rb_d,r_y-r_r/2-2.5*rb_d,-eps],
                [r_x+rb_d,r_r/2+rb_d/2,-eps],
                [r_x+rb_d,r_r/2+2.5*rb_d,-eps],
                [r_x+rb_d,r_y-r_r/2-rb_d/2,-eps],
                [r_x+rb_d,r_y-r_r/2-2.5*rb_d,-eps],
                    ];
    
    // interface
    
    difference()
    {
        translate([-rb_t,0,0])
            round_cube(x=r_x+2*rb_t,y=r_y,z=wt,d=r_r);
        for(point=points)
        {   
            translate(point)
                cylinder(d=rb_d,h=wt+2*eps);
        }
    }
}

rattle();

