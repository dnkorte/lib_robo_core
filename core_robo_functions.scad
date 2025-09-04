/*
 * Module: core_robo_functions.scad
 * this main file has configuration parameters and core modules
 * supporting OpenSCAD tools to generate parts for Open Robotics Platform 
 * (ORP) and MicroMouse (MM) parts
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
 *	20230819 	- Initial Release
 *  20241204    - modified to provide support for Micromouse libraries too
 */

/*
 * hex nut generator, from
 * https://github.com/chrisspen/openscad-extra
 *
 * this version makes a nut that fits properly in the nut receptacle on a 12mm hex RC wheel
 */

module make_hex_nut(w, h, d){
    // d = inner diameter
    // w = width across the flats
    // h = height or thickness
    s = w/sqrt(3);
    $fn = 100;
    
    translate([ 0, 0, h/2 ]) difference(){
        union(){
            for(i=[0:1:2]){
                rotate([0,0,120*i])
                cube([w, s, h], center=true);
            }
        }
        if(d){
            cylinder(d=d, h=h+1, center=true);
        }
    }
}

module make_12mm_hex_nut(w=11.4, h=4, d=4){
    s = w/sqrt(3);
    $fn = 100;
    
    make_hex_nut(w, h, d);
}

// this makes a nut shape for an M3 nut TO BE USED AS A CAVITY
module make_m3_hex_nut(w=5.7, h=2.7, d=0) {
    s = w/sqrt(3);
    $fn = 100;
    
    make_hex_nut(w, h, d);
}

/*
 * this generates a box with rounded corners
 * the box is centered on the origin, running "up" from z=0
 * reference: https://hackaday.com/2018/02/13/openscad-tieing-it-together-with-hull/
 */
module roundedbox(x, y, radius=3, height=3) {
    left_x = -(x/2) + radius;
    right_x = (x/2) - radius;
    bottom_y = -(y/2) + radius;
    top_y = +(y/2) - radius;
    
    points = [ [left_x, bottom_y,0], [left_x, top_y,0], [right_x, top_y,0], [right_x, bottom_y,0] ]; 
    hull() {
        for (p=points) {
            translate(p) cylinder(r=radius, h=height);
        }
    }
}

/*
 * module prism generates a basic "wedge" shape that can be used vertically to make support-less
 * 3d-printable shelves; this is defined in openSCAD documentation at:
 *      https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids
 */

module prism(x, y, z) {
   polyhedron(
           points=[[0,0,0], [x,0,0], [x,y,0], [0,y,0], [0,y,z], [x,y,z]],
           faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
           );
}

module prism_lwh(l, w, h) {
   polyhedron(
           points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
           faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
           );
}


/* 
 * this makes a right triangle plate, with sides on x and y axis and thickness z
 * https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids
 */
module right_triangle(x, y, z) {
        points=[
            [0,0,0],  // 0
            [x,0,0],  // 1
            [0,y,0],  // 2
            [0,0,z],  // 3
            [x,0,z],  // 4
            [0,y,z]]; // 5 

        faces=[
                [0,1,2],     // bottom
                [3,5,4],     // top
                [0,3,4,1],   // front side
                [2,5,3,0],   // left side
                [1,4,5,2]];   // hypotenuse side 

   polyhedron( points, faces );
}


/*
 * ***************************************************************************
 * components in this section create shafts (flat, d-shaft, etc)
 * ***************************************************************************
 */


/*
 * ***************************************************************************
 * module shaft_flat() makes a flattened shaft
 * this is a round cylinder, with flats on 2 sides (ie for a TT motor)
 *  
 * this is generated in xy plane, centered at origin, pointed "up" (towards + Z)
 * it should be "added" to design, there are no holes needed at placement level
 *
 * parameters:
 *      diameter    diameter of round part of shaft, in mm
 *      flatwidth   dimension across flat part in mm (flat-to-flat)
 *      length      length (or height) of shaft
 *      orientation "tall" or "wide" 
 *          (for tall, initial flats are on left/right (+/- x sides))
 * ***************************************************************************
 */
module shaft_flat(diameter, flatwidth, length, orientation="tall") {
    remove_from_each_side = (diameter - flatwidth) / 2;

    if (orientation == "tall") {
        difference() {
            cylinder(r=(diameter/2), h=length);
            translate([ -(diameter/2), -(diameter/2), -0.1 ]) 
                cube([ remove_from_each_side, diameter, length+0.2 ]);
            translate([ (diameter/2)-remove_from_each_side, -(diameter/2), -0.1 ]) 
                cube([ remove_from_each_side, diameter, length+0.2 ]);
        }
    } else {
        rotate([ 0, 0, -90 ]) difference() {
            cylinder(r=(diameter/2), h=length);
            translate([ -(diameter/2), -(diameter/2), -0.1 ]) 
                cube([ remove_from_each_side, diameter, length+0.2 ]);
            translate([ (diameter/2)-remove_from_each_side, -(diameter/2), -0.1 ]) 
                cube([ remove_from_each_side, diameter, length+0.2 ]);
        }
    }
}

/*
 * ***************************************************************************
 * module shaft_d() makes a d-shaft
 * this is a round cylinder, with flat on 1 side
 *  
 * this is generated in xy plane, centered at origin, pointed "up" (towards + Z)
 * it should be "added" to design, there are no holes needed at placement level
 *
 * parameters:
 *      diameter        diameter of round part of shaft, in mm
 *      fractionremoved  portion of diameter removed (ie 0.1 - 0.9)
 *      length          length (or height) of shaft
 *      orientation     "tall" or "wide" 
 *          (for tall, initial flats are on left/right (+/- x sides))
 * ***************************************************************************
 */
module shaft_d(diameter, fractionremoved, length, orientation="tall") {
    remove_amount = (diameter * fractionremoved);

    if (orientation == "tall") {
        difference() {
            cylinder(r=(diameter/2), h=length);
            translate([ (diameter/2)-remove_amount, -(diameter/2), -0.1 ]) 
                cube([ remove_amount, diameter, length+0.2 ]);
        }
    } else {
        rotate([ 0, 0, -90 ]) difference() {
            cylinder(r=(diameter/2), h=length);
            translate([ (diameter/2)-remove_amount, -(diameter/2), -0.1 ])  
                cube([ remove_amount, diameter, length+0.2 ]);
        }
    }
}

/*
 * ***************************************************************************
 * module shaft_d_r() makes a d-shaft
 * this is a round cylinder, with flat on 1 side
 *  
 * this is generated in xy plane, centered at origin, pointed "up" (towards + Z)
 * it should be "added" to design, there are no holes needed at placement level
 *
 * parameters:
 *      diameter        diameter of round part of shaft, in mm
 *      flat_radius     radius to flat wall on cutoff side
 *      length          length (or height) of shaft
 *      orientation     "tall" or "wide" 
 *          (for tall, initial flats are on left/right (+/- x sides))
 * ***************************************************************************
 */
module shaft_d_r(diameter, flat_radius, length, orientation="tall") {
    remove_amount = ((diameter/2) - flat_radius);

    if (orientation == "tall") {
        difference() {
            cylinder(r=(diameter/2), h=length);
            translate([ (diameter/2)-remove_amount, -(diameter/2), -0.1 ]) 
                cube([ remove_amount, diameter, length+0.2 ]);
        }
    } else {
        rotate([ 0, 0, -90 ]) difference() {
            cylinder(r=(diameter/2), h=length);
            translate([ (diameter/2)-remove_amount, -(diameter/2), -0.1 ])  
                cube([ remove_amount, diameter, length+0.2 ]);
        }
    }
}


/*
 * generators for mount cones (for boards)
 */

module component_mount_cone(height=mount_cone_height) {
    cylinder(d2=mount_cone_top_dia, d1=mount_cone_bot_dia, h=height);
}

module component_mount_cylinder(height=mount_cone_height) {
    cylinder(d=mount_cone_top_dia, h=height);
}


module M20_threadhole(height=mount_cone_height) {
    if (TI20_use_threaded_insert) {
        translate([ 0, 0, 0.1 ]) cylinder( d= TI20_threaded_insert_dia, h=height+0.2);
    } else {
        translate([ 0, 0, 0.1 ]) cylinder( d= M2_selftap_dia, h=height+0.2);
    }
}

module M25_threadhole(height=mount_cone_height) {
    if (TI25_use_threaded_insert) {
        translate([ 0, 0, 0.1 ]) cylinder( d= TI25_threaded_insert_dia, h=height+0.2);
    } else {
        translate([ 0, 0, 0.1 ]) cylinder( d= M25_selftap_dia, h=height+0.2);
    }
}

module M3_threadhole(height=mount_cone_height) {
    if (TI30_use_threaded_insert) {
        translate([ 0, 0, 0.1 ]) cylinder( d= TI30_threaded_insert_dia, h=height+0.2);
    } else {
        translate([ 0, 0, 0.1 ]) cylinder( d= M3_selftap_dia, h=height+0.2);
    }
}

module M3_mount_cyl_with_bolthole(height=mount_cone_height) {
    difference() {
        component_mount_cylinder(height);
        if (TI30_use_threaded_insert) {
            translate([ 0, 0, height-8 ]) cylinder( d= TI30_threaded_insert_dia, h=8.1);
        } else {
            translate([ 0, 0, height-8 ]) cylinder( d= M3_selftap_dia, h=8.1);
        }
    }
}

module M25_mount_cyl_with_bolthole( height=mount_cone_height) {
    difference() {
        component_mount_cylinder(height);
        if (TI25_use_threaded_insert) {
            translate([ 0, 0, height-8 ]) cylinder( d= TI25_threaded_insert_dia, h=8.1);
        } else {
            translate([ 0, 0, height-8 ]) cylinder( d= M25_selftap_dia, h=8.1);
        }
    }
}

module M20_mount_cyl_with_bolthole( height=mount_cone_height) {
    difference() {
        component_mount_cylinder(height);
        if (TI20_use_threaded_insert) {
            translate([ 0, 0, height-8 ]) cylinder( d= TI20_threaded_insert_dia, h=8.1);
        } else {
            translate([ 0, 0, height-8 ]) cylinder( d= M20_selftap_dia, h=8.1);
        }
    }
}

module M20_passthru_hole(height=mount_cone_height) {
    translate([ 0, 0, 0.1 ]) cylinder( d= M2_throughhole_dia, h=height+0.2);
}


module M25_passthru_hole(height=mount_cone_height) {
    translate([ 0, 0, 0.1 ]) cylinder( d= M25_throughhole_dia, h=height+0.2);
}


module M3_passthru_hole(height=mount_cone_height) {
    translate([ 0, 0, 0.1 ]) cylinder( d= M3_selftap_dia, h=height+0.2);
}


/* 
 * mount_size:   "M3", "M25", "M2"
 * vorh:  "h"=(prints horizontally), "v"=(prints vertically; mount cylinders conical for support-less printing)
 */

module component_4_post_board( bd_length, bd_width, screw_x, screw_y, mount_size="M3", board_label="", lift=mount_cone_height, vorh="h" ) {
    difference() {
        union() {
            roundedbox(bd_length, bd_width, 2, board_thick);

            // mount towers    
            if (vorh == "h") {  
                translate([ -(screw_x/2), -(screw_y/2), 1]) component_mount_cylinder(lift); 
                translate([ -(screw_x/2), +(screw_y/2), 1]) component_mount_cylinder(lift);
                translate([ +(screw_x/2), -(screw_y/2), 1]) component_mount_cylinder(lift);
                translate([ +(screw_x/2), +(screw_y/2), 1]) component_mount_cylinder(lift);      
            } else {
                translate([ -(screw_x/2), -(screw_y/2), 0]) component_mount_cone(lift); 
                translate([ -(screw_x/2), +(screw_y/2), 0]) component_mount_cone(lift);
                translate([ +(screw_x/2), -(screw_y/2), 0]) component_mount_cone(lift);
                translate([ +(screw_x/2), +(screw_y/2), 0]) component_mount_cone(lift); 
            }

            // identification
            translate([0, -3, board_thick]) linear_extrude(2) text(board_label, 
                size=5,  halign="center", font = "Liberation Sans:style=Bold");
            translate([0, +4, board_thick]) linear_extrude(1.4) text(mount_size, 
                size=5,  halign="center", font = "Liberation Sans:style=Bold");
        }
            
        // mount tower holes  
        if (mount_size == "M3") {   
            translate([ -(screw_x/2), -(screw_y/2), -0.1]) M3_threadhole(lift+board_thick+0.2); 
            translate([ -(screw_x/2), +(screw_y/2), -0.1]) M3_threadhole(lift+board_thick+0.2);
            translate([ +(screw_x/2), -(screw_y/2), -0.1]) M3_threadhole(lift+board_thick+0.2);
            translate([ +(screw_x/2), +(screw_y/2), -0.1]) M3_threadhole(lift+board_thick+0.2);
        } else if (mount_size == "M25") {
            translate([ -(screw_x/2), -(screw_y/2), -0.1]) M25_threadhole(lift+board_thick+0.2); 
            translate([ -(screw_x/2), +(screw_y/2), -0.1]) M25_threadhole(lift+board_thick+0.2);
            translate([ +(screw_x/2), -(screw_y/2), -0.1]) M25_threadhole(lift+board_thick+0.2);
            translate([ +(screw_x/2), +(screw_y/2), -0.1]) M25_threadhole(lift+board_thick+0.2);
        } else {
            translate([ -(screw_x/2), -(screw_y/2), -0.1]) M20_threadhole(lift+board_thick+0.2); 
            translate([ -(screw_x/2), +(screw_y/2), -0.1]) M20_threadhole(lift+board_thick+0.2);
            translate([ +(screw_x/2), -(screw_y/2), -0.1]) M20_threadhole(lift+board_thick+0.2);
            translate([ +(screw_x/2), +(screw_y/2), -0.1]) M20_threadhole(lift+board_thick+0.2);
        }
    }
}

/* 
 * mount_size:   "M3", "M25", "M2"
 * screw_y is the distance of the "top" row of screw holes FROM THE TOP EDGE OF THE BOARD
 * vorh:  "h"=(prints horizontally), "v"=(prints vertically; mount cylinders conical for support-less printing)
 */

module component_2_post_board( bd_length, bd_width, screw_x, screw_y=2.54, mount_size="M3", board_label="", lift=mount_cone_height, vorh="h" ) {
    difference() {
        union() {
            roundedbox(bd_length, bd_width, 2, board_thick);

            // mount towers     
            if (vorh == "h") {      
                translate([ -(screw_x/2), +(bd_width/2)-screw_y, 1]) component_mount_cylinder(lift);
                translate([ +(screw_x/2), +(bd_width/2)-screw_y, 1]) component_mount_cylinder(lift); 
                } else {
                translate([ -(screw_x/2), +(bd_width/2)-screw_y, 1]) component_mount_cylinder(lift);
                translate([ +(screw_x/2), +(bd_width/2)-screw_y, 1]) component_mount_cylinder(lift); 
            }

            // identification
            translate([0, -3, board_thick]) linear_extrude(2) text(board_label, 
                size=5,  halign="center", font = "Liberation Sans:style=Bold");
            translate([0, +4, board_thick]) linear_extrude(1.4) text(mount_size, 
                size=5,  halign="center", font = "Liberation Sans:style=Bold");
        }
            
        // mount tower holes 
        if (mount_size == "M3") {     
            translate([ -(screw_x/2), +(bd_width/2)-screw_y, -0.1]) M3_threadhole(lift+board_thick+0.2);
            translate([ +(screw_x/2), +(bd_width/2)-screw_y, -0.1]) M3_threadhole(lift+board_thick+0.2);
        } else if (mount_size == "M25") {
            translate([ -(screw_x/2), +(bd_width/2)-screw_y, -0.1]) M25_threadhole(lift+board_thick+0.2);
            translate([ +(screw_x/2), +(bd_width/2)-screw_y, -0.1]) M25_threadhole(lift+board_thick+0.2);
        } else {
            translate([ -(screw_x/2), +(bd_width/2)-screw_y, -0.1]) M20_threadhole(lift+board_thick+0.2);
            translate([ +(screw_x/2), +(bd_width/2)-screw_y, -0.1]) M20_threadhole(lift+board_thick+0.2);
        }
    }
}