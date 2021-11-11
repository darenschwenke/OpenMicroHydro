
clearance=0.27; // kerf where we need it..
extra=0.01;

t=3;

shaft_r=10/2;
turbine_r=180/2;

turbine_or=turbine_r+2*t*1.5;
turbine_blade_c=60;
turbine_blade_r=3*t;
turbine_blade_h=t*3+clearance;

turbine_blade_pitch=24;

turbine_jet_r=3/2;
turbine_jet_c=3;

$fn=turbine_blade_c*3;

module turbine_blade_profile() {
	difference() {
		union() {
			translate([0,-turbine_blade_r/4-turbine_blade_r/2]) square([turbine_blade_r*4,t*4],center=true);
			translate([0,-turbine_blade_r/4]) square([turbine_blade_r*4+t*2,t*4],center=true);
		}
		for (x=[-1,1]) translate([x*turbine_blade_r,turbine_blade_r/2]) circle(r=turbine_blade_r+extra,center=true);
	}
}

module cutout_profile() {
	translate([turbine_r/2,0]) circle(r=t,center=true);
	translate([turbine_r-t*6,0]) circle(r=t*3,center=true);
}

module extrude_cup() {
	linear_extrude(height=t,convexity=10,twist=0,center=true) turbine_blade_profile();
}

module extrude_disc(cut=0) {
	linear_extrude(height=t,convexity=10,twist=0,center=true) disc(cut=cut);
}

module disc(cut=0) {
	difference() {
		circle(r=turbine_or,center=true);
		circle(r=shaft_r-clearance/2,center=true);
		for (r=[0:360/turbine_blade_c:360]) rotate([0,0,r]) translate([turbine_r,0]) rotate([0,0,turbine_blade_pitch]) square([t-clearance,t*4-clearance*2],center=true);
		for (r=[0:360/turbine_blade_c*6:360]) hull() {
			rotate([0,0,r]) rotate([0,0,90]) cutout_profile();
			rotate([0,0,r+360/turbine_blade_c*1.5]) rotate([0,0,90]) cutout_profile();
		}
		if (cut) circle(r=turbine_r-turbine_blade_r,center=true);
	}
}
module visualize_turbine() {
	#for (r=[0:360/turbine_blade_c:359]) rotate([0,0,r]) translate([t/2,turbine_r+t/1.5+clearance,turbine_blade_r*2+t/2]) rotate([0,90,0]) rotate([90-turbine_blade_pitch,0,0]) linear_extrude(height=t) turbine_blade_profile();
	for (z=[0,1]) translate([0,0,z*(turbine_blade_r*4+t)]) extrude_disc(cut=z);
	
}
module visualize_jets() {

	for (r=[0:1:turbine_jet_c]) rotate([0,0,r*360/turbine_jet_c]) translate([t/2,turbine_r+t/1.5+clearance,turbine_blade_r*2+t/2]) rotate([0,90,0]) translate([0,-turbine_blade_r,100]) cylinder(r=t/4,h=100,center=true);
}

module turbine_blade_stack() {
	for (y=[0:5]) translate([0,-turbine_blade_r*4+y*turbine_blade_r*1.9]) turbine_blade_profile();
}


module simulate_segment() {
	for (r=[0:1:360/turbine_blade_c]) rotate([0,0,r]) visualize_jets();
	visualize_turbine();
}
module turbine_housing() {
	linear_extrude(height=turbine_blade_r*4+t*4) difference() {
		circle(r=turbine_r+6*t,center=true); 
		circle(r=turbine_r+4*t,center=true);
	}
} 

module visualize_assembly() {
	if (0) for (r=[0:1:360/turbine_blade_c]) rotate([0,0,r]) visualize_jets();
	visualize_jets();
	visualize_turbine();
	translate([0,0,-t*2]) turbine_housing();
}


//simulate_segment();
//turbine_blade_profile();
//turbine_blade_stack();
//visualize_jets();
//visualize_turbine();
//visualize_assembly();
disc(cut=1);

	
