$fn = 90;
eps = 0.01;

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

// z paramters
// handle thickness
ht = 2.5;
// back curved area thickness
bat = 8;
// back curver area length
bal = 30;


module handle_hole()
{
    difference()
    {
        // main shape in the size of the back hole
        hull()
        {
            translate([hl-db/2,0,0])                    
                hull()
                {
                    cylinder(d=db,h=bat);
                    translate([0,-db,0])
                        cylinder(d=db,h=bat);
                }
                
            translate([0,-wf/2,0])
                hull()
                {
                    cube([1,wf,bat]);
                    translate([0,-db,0])
                        cube([1,wf,bat]);
                }
        }
        
        // cuting front part
        translate([-eps,-3*db/2,ht])
            cube([hl-bal,2*db,bal]);   
    }
}

//handle_hole();

module handle()
{
    difference()
    {
        translate([eps,0,ht/2])
            rotate([0,90,0])
                hull()
                {
                    // front area
                    cylinder(d=2*wt+wf,h=1);
                    // back ball
                    translate([0,0,hl-db/2])
                        sphere(d=2*wt+db);
                }
            handle_hole();
    }
}

handle();