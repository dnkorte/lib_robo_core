/*
 * Module: core_parts_wheels.scad
 * this main file has generators for components used in DonKbot_mm projects
 *
 * Project:   robo_scad (core)
 * Author(s): Don Korte
 * github:    https://github.com/dnkorte/lib_robo_core
 * 
 * *************************************************************************
 * NOTE that this core module provides components / modules for a variety of projects.
 * it (and project modules) gets dimensions and some basic function support from core library
 * functions that (on the author's system) are stored in a different 
 * folder from project folders because they are used by a variety of projects.  they are
 * included by the main module so that they can be accessed here.
 * if the user does not expect to have multiple projects accessing those
 * libraries, they may be stored in the project folder containing the 
 * main module (project file).
 *  
 * the core libraries include: 
 *      core_robo_functions.scad 
 *      core_config_dimensions.scad
 *      core_parts_wheels.scad
 * 
 * if they are stored in a remote location, you may use a system ENVIRONMENT
 * VARIABLE called OPENSCADPATH to allow OpenSCAD to find them at that location.
 *
 * to implement the F library functionality, setup the environment var as follows:
 *      on linux, store a file called /etc/profile.d/openscadpath.sh with contents:  
 *          export OPENSCADPATH="/home/the_rest_of_the_path/" 
 *          (note that ~/.bashrc fails because its not run from terminal session)
 *      on Windows, by Control Panel / System / Advanced System Settings / Environment Variables / User Variable 
 * see https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries   for details
 * *************************************************************************
 *   
 * MIT License
 * 
 * Copyright (c) 2024 Don Korte
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 * *************************************************************************
 *
 *  
 * Reference:
 *  https://github.com/dnkorte/donkbot
 *  https://github.com/dnkorte/lib_robo_core
 *  https://donstechstuff.com/
 *  https://openscad.org/
 *  https://donstechstuff.com
 *  https://openroboticplatform.com/
 *
 * Version History:
 *  20241204    - Initial Release
 */

/*
* module part_wheel_dshaft() generates a wheel that uses an oring for traction
* @param oring_ID:  original oring Inner Diameter (ID)
* @param oring_OD:  original oring Outer Diameter (OD)
* @param dshaft_dia	diameter of d_shaft (typically 3.0 or 4.0)
* @param stretch:	added dimension for wheel base that makes it bigger
*					and provides some stretch to the oring.  it is the amount
*					added to the ID and OD values (in mm for DIAMETER)
*					NOTE: with a stretch of 2 it ends up making a finished wheel
*					with an outer diameter just about 1 mm larger than the nominal oring OD
* @param thick:		wheel thickness in mm
 */

module part_wheel_dshaft( oring_ID, oring_OD, thick = 6, dshaft_dia = 3.0, stretch = 2 ) {
	tube_dia = (oring_OD - oring_ID)/2;
	tube_radius = tube_dia / 2;
	torus_dia = (oring_ID + oring_OD)/2;	// diameter at center of torus tube
	torus_radius = torus_dia / 2;
	base_wheel_dia = (oring_ID + tube_dia + stretch - 1);
	center_hub_dia = (dshaft_dia+4);
	center_hub_thick = 7;
	shaft_clearance = 0.5;
	web_diameter = (base_wheel_dia - 6);

	difference() {
		union() {
			// make a basic cylinder for wheel that is mostly thin, but fattened to "thick" near the outside
			difference() {
				cylinder( d=base_wheel_dia, h=thick);
				translate([ 0, 0, 2 ]) cylinder( d=web_diameter, h=(thick - 1.9));
			}
			// then add a thicker cylinder (hub) in center to engage motor's dshaft
			cylinder (d=center_hub_dia, h=center_hub_thick);
		}

		// then dig a "tunnel" to cradle the o-ring
		// note for torus function, first param is sort of like the thickness of the rubber tube
		// and the second param is the centerline circle radius (like the radius of the wheel)
		translate([ 0, 0, (thick/2) ]) torus( tube_radius, (torus_radius - tube_radius/4 + (stretch/2)) );

		// then put in a hole for the dshaft
		translate([ 0, 0, -0.1 ]) shaft_d( (dshaft_dia + shaft_clearance), 0.25, max(thick, center_hub_thick)+0.2, "tall");

		// and make a gap across the wheel to provide flexibilty for clasping the dshaft 
		translate([ -(base_wheel_dia/2), -0.5, -0.1 ]) cube([ base_wheel_dia/2, 1, max(thick, center_hub_thick)+0.2 ]);


		// make 4 holes around web of wheel, just to be pretty
		web_ring_radius = (web_diameter/2 + center_hub_dia/2) / 2;
		if (oring_OD < 40) {
			rotate([ 0, 0, 45 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=6, h=2.2);
			rotate([ 0, 0, 135 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=6, h=2.2);
			rotate([ 0, 0, -45 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=6, h=2.2);
			rotate([ 0, 0, -135 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=6, h=2.2);
		} else {
			rotate([ 0, 0, 0 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=8, h=2.2);
			rotate([ 0, 0, 60 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=8, h=2.2);
			rotate([ 0, 0, 120 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=8, h=2.2);
			rotate([ 0, 0, 180 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=8, h=2.2);
			rotate([ 0, 0, 240 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=8, h=2.2);
			rotate([ 0, 0, 300 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=8, h=2.2);
		}
	}
}



/*
* module part_wheel_tt() generates a wheel that uses an oring for traction and fits on a TT Motor
* @param oring_ID:  original oring Inner Diameter (ID)
* @param oring_OD:  original oring Outer Diameter (OD)
* @param thick:		wheel thickness in mm
* @param screw:		screwsize for tapping into shaft;  "M25" or "M3"
*					(adafruit yellow 200 rpm = M25;  blue 48 rpm = M3)
* @param stretch:	added dimension for wheel base that makes it bigger
*					and provides some stretch to the oring.  it is the amount
*					added to the ID and OD values (in mm for DIAMETER)
*					NOTE: with a stretch of 2 it ends up making a finished wheel
*					with an outer diameter just about 1 mm larger than the nominal oring OD
 */

module part_wheel_tt( oring_ID, oring_OD, thick = 6, screw = "M25", stretch = 2 ) {
	tube_dia = (oring_OD - oring_ID)/2;
	tube_radius = tube_dia / 2;
	torus_dia = (oring_ID + oring_OD)/2;	// diameter at center of torus tube
	torus_radius = torus_dia / 2;
	base_wheel_dia = (oring_ID + tube_dia + stretch - 1);
	center_hub_dia = 8;
	center_hub_thick = 9;
	shaft_w = 3.7;
	shaft_l = 5.5;
	shaft_clearance = 0.35;
	web_diameter = (base_wheel_dia - 6);

	difference() {
		union() {
			// make a basic cylinder for wheel that is mostly thin, but fattened to "thick" near the outside
			difference() {
				cylinder( d=base_wheel_dia, h=thick);
				translate([ 0, 0, 2 ]) cylinder( d=web_diameter, h=(thick - 1.9));
			}
			// then add a thicker cylinder (hub) in center to engage motor's dshaft
			cylinder (d=center_hub_dia, h=center_hub_thick);
		}

		// then dig a "tunnel" to cradle the o-ring
		// note for torus function, first param is sort of like the thickness of the rubber tube
		// and the second param is the centerline circle radius (like the radius of the wheel)
		translate([ 0, 0, (thick/2) ]) torus( tube_radius, (torus_radius - tube_radius/4 + (stretch/2)) );
 
		// then put in a hole for the motor shaft
		translate([ 0, 0, -0.1 ]) 
			shaft_flat( shaft_l + shaft_clearance, shaft_w + shaft_clearance, (center_hub_thick - 3 ));   // shaft  

		// and a hole for  screw to attach the wheel
		if (screw == "M25") {
			translate([ 0, 0, (center_hub_thick - 3.1) ]) cylinder (d=M25_throughhole_dia, h=3.3);
		} else {
			translate([ 0, 0, (center_hub_thick - 3.1) ]) cylinder (d=M3_throughhole_dia, h=3.3);
		}

		// make 4 holes around web of wheel, just to be pretty
		web_ring_radius = (web_diameter/2 + center_hub_dia/2) / 2;
		if (oring_OD < 40) {
			rotate([ 0, 0, 45 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=6, h=2.2);
			rotate([ 0, 0, 135 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=6, h=2.2);
			rotate([ 0, 0, -45 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=6, h=2.2);
			rotate([ 0, 0, -135 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=6, h=2.2);
		} else {
			rotate([ 0, 0, 0 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=8, h=2.2);
			rotate([ 0, 0, 60 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=8, h=2.2);
			rotate([ 0, 0, 120 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=8, h=2.2);
			rotate([ 0, 0, 180 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=8, h=2.2);
			rotate([ 0, 0, 240 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=8, h=2.2);
			rotate([ 0, 0, 300 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=8, h=2.2);
		}
	}
}


/*
* module part_wheel_dshaft() generates a wheel that uses an oring for traction and fits on a round shaft
* @param oring_ID:  original oring Inner Diameter (ID)
* @param oring_OD:  original oring Outer Diameter (OD)
* @param dshaft_dia	diameter of d_shaft (typically 3.0 or 4.0)
* @param stretch:	added dimension for wheel base that makes it bigger
*					and provides some stretch to the oring.  it is the amount
*					added to the ID and OD values (in mm for DIAMETER)
*					NOTE: with a stretch of 2 it ends up making a finished wheel
*					with an outer diameter just about 1 mm larger than the nominal oring OD
* @param thick:		wheel thickness in mm
 */

module part_wheel_roundshaft( oring_ID, oring_OD, thick = 6, shaft_dia = 3.0, stretch = 2 ) {
	tube_dia = (oring_OD - oring_ID)/2;
	tube_radius = tube_dia / 2;
	torus_dia = (oring_ID + oring_OD)/2;	// diameter at center of torus tube
	torus_radius = torus_dia / 2;
	base_wheel_dia = (oring_ID + tube_dia + stretch - 1);
	center_hub_dia = (shaft_dia+4);
	center_hub_thick = 7;
	shaft_clearance = 0.3;
	web_diameter = (base_wheel_dia - 6);

	difference() {
		union() {
			// make a basic cylinder for wheel that is mostly thin, but fattened to "thick" near the outside
			difference() {
				cylinder( d=base_wheel_dia, h=thick);
				translate([ 0, 0, 2 ]) cylinder( d=web_diameter, h=(thick - 1.9));
			}
			// then add a thicker cylinder (hub) in center to engage motor's dshaft
			cylinder (d=center_hub_dia, h=center_hub_thick);
		}

		// then dig a "tunnel" to cradle the o-ring
		// note for torus function, first param is sort of like the thickness of the rubber tube
		// and the second param is the centerline circle radius (like the radius of the wheel)
		translate([ 0, 0, (thick/2) ]) torus( tube_radius, (torus_radius - tube_radius/4 + (stretch/2)) );

		// then put in a hole for the round motor shaft
		translate([ 0, 0, -0.1 ]) cylinder( d=shaft_dia + shaft_clearance, h=max(thick, center_hub_thick)+0.2 );

		// and make a gap across the wheel to provide flexibilty for clasping the dshaft 
		translate([ -(base_wheel_dia/2), -0.5, -0.1 ]) cube([ base_wheel_dia/2, 1, max(thick, center_hub_thick)+0.2 ]);


		// make 4 holes around web of wheel, just to be pretty
		web_ring_radius = (web_diameter/2 + center_hub_dia/2) / 2;
		if (oring_OD < 40) {
			rotate([ 0, 0, 45 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=6, h=2.2);
			rotate([ 0, 0, 135 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=6, h=2.2);
			rotate([ 0, 0, -45 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=6, h=2.2);
			rotate([ 0, 0, -135 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=6, h=2.2);
		} else {
			rotate([ 0, 0, 0 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=8, h=2.2);
			rotate([ 0, 0, 60 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=8, h=2.2);
			rotate([ 0, 0, 120 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=8, h=2.2);
			rotate([ 0, 0, 180 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=8, h=2.2);
			rotate([ 0, 0, 240 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=8, h=2.2);
			rotate([ 0, 0, 300 ]) translate([ web_ring_radius, 0, -0.1 ]) cylinder( d=8, h=2.2);
		}
	}
}