eps = 0.01;
$fn=100;
// replace a simple cylinder with a middle tapered pair
// height, radius and offset for the triangular profile
module peg(h,r,o) {
	union(){
		cylinder(r1=r+o,r2=r, h=h/2);
		translate([0,0,-h/2])
			cylinder(r1=r,r2=r+o, h=h/2);
	}
}

//Following "Circle Squaring, a mechanical view" by Cox and Wagon
//width of the rotor, height of the rotor, offset for the of triangular profile (> 0)
module rotor(w,h,o,r_h,r_k,h_k){
	//length unit
	u = 0.5*w;
	translate([0,u*(sqrt(2)-1),h/2])
	difference(){
		union(){
			intersection(){
				peg(h,u*sqrt(2),o);
				translate([+u,-u,0])
					peg(h,u*2,o);
				translate([-u,-u,0])
					peg(h,u*2,o);
				translate([0,-u*(2-sqrt(2)),0])
					cube([u*4,u*2,h],center=true);
			}
			peg(h,u*(2-sqrt(2)),o);
			translate([.6*u,-0.85*u,0])
			cylinder(r=r_k,h=h+h_k);
		}
		cylinder(h=2*h,r=r_h,center=true);
	}
}

// h = height
// w = bottom square
// r = radius offset top larger than bottom
module SquareTrapezoid(w,r,h)
{
	m = w+r;
	polyhedron(
	points=[
		[0,0,0], [0,w,0], [w,w,0], [w,0,0], // bottom
		[-r,-r,h], [-r,m,h], [m,m,h], [m,-r,h]], // top
	triangles = [ // 6 faces
		 [0,2,1], [0,3,2], // bottom
		 [4,5,6], [4,6,7], // top
		 [0,4,7], [0,7,3], // front
		 [1,2,6], [1,6,5], // back
		 [1,5,4], [1,4,0], // left
		 [3,7,2], [2,7,6]] // right
	);
}

//width of the rotor (inner size), height, offset for profile, thickness of frame
module frame(w,h,o,t){
	translate([0,0,h/2])
	difference(){
		cube([w+2*t,w+2*t,h],center=true);
		translate([0,0,h/2+eps])
			rotate([0,180,0])
				translate([-w/2,-w/2,0])
					SquareTrapezoid(w,o,h/2+eps);
		translate([-w/2,-w/2,-h/2-eps])
			SquareTrapezoid(w,o,h/2+2*eps);
	}

}

union(){
	frame(51.5,5,3,7);
	rotor(50,5,3,2,3,8);
}
