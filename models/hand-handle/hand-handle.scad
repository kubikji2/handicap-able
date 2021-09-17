// general parameters
eps = 0.01;
$fn = 90;

// contact area height
c_h = 60;
// contact area diameter
c_d = 15;

// enders height
e_h = 5;
// enders diameters 
e_d = 20;

// transition height
t_h = (e_d-c_d);


module hand_handle()
{
    // lower end
    cylinder(d=e_d, h=e_h);
    // lower transition
    translate([0,0,e_h])
        cylinder(d1=e_d, d2=c_d, h=t_h);
    // main area
    translate([0,0,e_h+t_h])
        cylinder(d=c_d,h=c_h);
    // upper transition
    translate([0,0,e_h+t_h+c_h])
        cylinder(d1=c_d, d2=e_d, h=t_h);
    // upper end
    translate([0,0,e_h+t_h+c_h+t_h])
        cylinder(d=e_d, h=e_h);
}

//hand_handle();

module handle_debug()
{
    difference()
    {
        // main geometry
        hand_handle();
        
        // debug info
        f_s = 5;
        _h = 2*e_h + 2*t_h + c_h; 
        // enders diameter
        translate([0,e_d/4,_h-0.5+eps])
            linear_extrude(0.5)
                text(font="Consolas:style=Regular",
                size=f_s, halign="center", valign="center",
                text = str("c", c_d));
        // contact area diameter
        translate([0,-e_d/4,_h-0.5+eps])
            linear_extrude(0.5)
                text(font="Consolas:style=Regular",
                size=f_s, halign="center", valign="center",
                text = str("e", e_d));
    }
}

handle_debug();