
module round_cube (x=40,y=30,z=2,d=10)
{
    assert(x >= d && y >= d, str("given diameter(d=",d,") exceed one of sides(x=",x,",y=",y,")! Use round_cube_lazy to automatically choose diameter."));
    
    A = x-d;
    B = y-d;
    C = z;
    
    translate([d/2,d/2,0])
    hull()
    {
        cylinder(d=d, h=C);
        translate([A,0,0]) cylinder(d=d, h=C);
        translate([A,B,0]) cylinder(d=d, h=C);
        translate([0,B,0]) cylinder(d=d, h=C);
    }   
}

module sphere_cube (x=40,y=30,z=2,d=10)
{
    assert(x >= d && y >= d, str("given diameter(d=",d,") exceed one of sides(x=",x,",y=",y,")! Use round_cube_lazy to automatically choose diameter."));
    
    A = x-d;
    B = y-d;
    C = z-d;
    R = d/2;
    
    /*
    points = [  [0,0,0],
                [A,0,0],
                [A,B,0],
                [0,B,0],
                [0,0,C],
                [A,0,C],
                [A,B,C],
                [0,B,C]];
    */
    
    translate([R,R,R])
        minkowski()
        {
            cube([A,B,C]);
            sphere(r=R);
        }
}

//sphere_cube();

//round_cube(x=5,y=10,d=20);

module round_cube_lazy(x=40,y=30,z=2,d=10)
{
    if (x<d || y<d)
    {
        echo("Avoiding dissaster by choosing new diameter.");
    }
    
    _d = min([x,y,d]);
    round_cube(x,y,z,_d);
}

//round_cube_lazy(x=5,y=10,d=20);

$fn = 45;
module box (x=82,y=154,z=52,d=20,t=2)
{
    A = x-d;
    B = y-d;
    C = z;
    
    //%translate([-d/2,-d/2,0]) cube([x,y,z]);
    difference()
    {
        hull()
        {
            cylinder(d=d, h=C);
            translate([A,0,0]) cylinder(d=d, h=C);
            translate([A,B,0]) cylinder(d=d, h=C);
            translate([0,B,0]) cylinder(d=d, h=C);
        }
        
        translate([-t/2,-t/2,t])
        hull()
        {
            translate([t,t,0]) cylinder(d=d-t, h=C);
            translate([A,t,0]) cylinder(d=d-t, h=C);
            translate([A,B,0]) cylinder(d=d-t, h=C);
            translate([t,B,0]) cylinder(d=d-t, h=C);
        }
    }
}

//box();