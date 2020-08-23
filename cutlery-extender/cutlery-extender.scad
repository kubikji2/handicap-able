$fn = 90;
eps = 0.01;
tol = 0.2;

// general parameters
// wall thickness
wt = 3;

// xy projection parameters
// diameter on the back of the spoon/fork handle
db = 19;
// front width of the spoon/fork handle
wf = 9;
// handle length
hl = 94;

// z parameters
// cuttlery handle thickness
// NOTE: 2.5 for spoon, 2.4 for fork
ht = 2.5;
// back curved area thickness
bat = 8;
// back curver area length
bal = 30;

// C-lock parameters
// - C-lock cutlery in the y axis
// - cl_ is used as pefix
//// locking pins diameter
//cl_d = 3;
// locking pins height
cl_h = 5;

// B-lock parameter
// - cutlery lock in the back of the extended handle
// - bl_ is used as prefix
// B-lock length
bl_l = 7;

// pins used in the C-lock
module pins(fd=wf+2*wt)
{
    /*
    // lock pins are in the middle of the space between the cutlery hole and the border
    lp_y_off = (wf/2+wt+ht/2)/2;
    translate([0,-lp_y_off,0])
        cylinder(d=cl_d,h=cl_h);
    translate([0,lp_y_off,0])
        cylinder(d=cl_d,h=cl_h);
    */
    difference()
    {
        // main body
        cylinder(d=fd,h=cl_h);
        // right cut
        translate([wt/2,-fd/2,-eps])
            cube([fd,fd,cl_h+2*eps]);
        // left cube
        translate([-fd-wt/2,-fd/2,-eps])
            cube([fd,fd,cl_h+2*eps]);
        // cutlery cut
        translate([-fd/2,-ht/2,-eps])
            cube([fd,ht,cl_h+2*eps]);
    }
}

// C-lock module used for fixing cutlery in the extender
module c_lock(  fd = wf+2*wt,
                left_handed = false)
{
    difference()
    {
        // main disk
        cylinder(d=fd,h=wt);
        // hole for cutlery
        y_off = left_handed ? 0 : db;
        translate([-wf/2,-ht/2,-eps])
            cube([wf+wt,ht,wt+2*eps]);
    }
    // lock pins
    translate([0,0,wt])
        pins();
    
}

//c_lock();


module handle_hole(left_handed = false)
{
    y_off = left_handed ? db : 0;
    translate([0,y_off,0])
    difference()
    {
        // main shape in the size of the back hole
        hull()
        {
            // rounded back
            translate([hl-db/2,0,0])
                hull()
                {
                    cylinder(d=db,h=bat);
                    translate([0,-db,0])
                        cylinder(d=db,h=bat);
                }   
            // WTF???
            translate([0,-wf/2,0])
                hull()
                {
                    cube([1,wf,bat]);
                    translate([0,-db,0])
                        cube([1,wf,bat]);
                }
        }
        
        // cutting front part
        translate([-eps,-3*db/2,ht])
            cube([hl-bal,2*db,bal]);
        
        // cutting for b-lock
        translate([hl-bl_l,-db,0])
            cube([bl_l,db,db]);
        
    }
    
    // adding hole for the cutlery handle
    _y_off = left_handed ? db : 0;
    translate([hl-db/2,-y_off+_y_off,0])
        cylinder(d=db,h=bat);
}

//handle_hole();

// VARIABLE PARAMETERS
// fd - front diameter
//    - is diameter closer to the spoon/fork front end (that part that is in contact with mouth)
// bd - back diameter
//    - is diameter of the sphere on the back end
// left_handed - determines whether the cutlery extender is used by left handed user
module handle(  fd = wf+2*wt,
                bd = db+2*wt,
                left_handed=true)
{
    difference()
    {
        translate([eps,0,ht/2])
            rotate([0,90,0])
                hull()
                {
                    // front area
                    cylinder(d=fd,h=1);
                    // back ball
                    translate([0,0,hl-db/2])
                        sphere(d=bd);
                }
        handle_hole();
        // drilling diameter labels
        f_s = 5;
        translate([f_s,0,fd/2+ht/2-1])
            linear_extrude(100)
                text(font="Consolas:style=Regular",
                size=f_s, halign="center", valign="center",
                text = str(fd));

        translate([hl-f_s-bd/4,0,bd/2+ht/2-1])
            linear_extrude(100)
                text(font="Consolas:style=Regular",
                size=f_s, halign="center", valign="center",
                text = str(bd));            
        
        // hole for the cutlery        
        handle_hole(left_handed=left_handed);
        
        // C-lock hole
        clh_t = 2*tol + wt;
        translate([-eps,-clh_t/2,-bd/2+ht/2])
            cube([cl_h,clh_t+tol,bd]);
    }
}

handle();




