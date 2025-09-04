/*
 * Module: core_config_dimensions.scad
 * this main file has configuration parameters and core modules
 * supporting OpenSCAD tools to generate parts for Open Robotics Platform 
 * (ORP) and DonKbot MicroMouse (MM) parts
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
 * parameters for threaded inserts
 */

TI20_use_threaded_insert = true;
TI25_use_threaded_insert = true;
TI30_use_threaded_insert = true;

TI20_threaded_insert_dia = 3.7;		// drill out to 3.2 mm if needed
TI25_threaded_insert_dia = 4.2;
TI30_threaded_insert_dia = 4.2;

TI_tower_dia = 7;

/*
 * parameters for holes that will be generated for screws
 * these may need to be fine-tuned for best results for your printer 
 * 
 * this is the only section that should need to be modified in this file
 */

M2_selftap_dia = 2.2;         
M2_throughhole_dia = 3.0;     
M25_selftap_dia = 2.6;
M25_throughhole_dia = 3.2;
M3_selftap_dia = 3.0;       
M3_throughhole_dia = 3.6;  
M4_throughhole_dia = 4.6;
M5_throughhole_dia = 5.6;


/*
 * parameters for mount cones (for boards)
 */ 

mount_cone_height = 6;
mount_cone_top_dia = 7;
mount_cone_bot_dia = 12;


/*
 * parameters for embedded nuts
 */
m3_nut_from_end = 4;
m3_nut_thick = 2.4;
m3_nut_e = 6.0;
m3_nut_s = 5.3;
nut_clearance_horiz = 0.65;  // was 0.6
nut_clearance_vert = 0.4;	// was 0.35

/*
 * parameters for connector tubes (ORP)
 */
m3_conn_dia = 12;
connector_stub_height = 10;
connector_stub_dia = 9;

/*
 * parameters for standard ORP grid
 */
orp_grid_hole_dia = 3.5;
orp_grid_hole_spacing = 20;
orp_grid_edge_safety_zone = 4;


board_thick = 2;

/*
 * dimensions for standard boards
 * boards are always generated in "landscape" orientation -- longest dimension is x
 */
board_dts_length = 57;
board_dts_width = 40;
board_dts_screw_x = 48;
board_dts_screw_y = 32;

board_dts_pwrdist_mount_spacing = 48;
board_dts_pwrdist_length = 55;
board_dts_pwrdist_width = 18;

board_smallmintproto_length = 54;
board_smallmintproto_width = 33;
board_smallmintproto_screw_x = 45.5;
board_smallmintproto_screw_y = 25.4;

board_stemma6_length = 28;
board_stemma6_width = 22;
board_stemma6_screw_x = 20.32;
board_stemma6_screw_y = 15.24;

board_stemma5_length = 28;
board_stemma5_width = 20;
board_stemma5_screw_x = 20.32;
board_stemma5_screw_y = 12.7;

board_tb6612_length = 26.67;
board_tb6612_width = 19.05;
board_tb6612_screw_x = 21.59;
board_tb6612_screw_y = 2.54;	// distance from long edge of board

board_pca9548_length = 40.64;
board_pca9548_width = 20.32;
board_pca9548_screw_x = 35.56;
board_pca9548_screw_y = 15.24;

board_matrix_length = 40.64;
board_matrix_width = 32.00;
board_matrix_screw_x = 36.58;
board_matrix_screw_y = 27.94;

board_ads7830_length = 1.3 * 25.4;
board_ads7830_width = 0.8 * 25.4;
board_ads7830_screw_x = 25.4;
board_ads7830_screw_y = 12.7;

board_feather_length = 54;
board_feather_width = 27;
board_feather_screw_x = 45.72;
board_feather_screw_y = 17.78;

board_dualfeather_length = 54;
board_dualfeather_width = 50;
board_dualfeather_screw_x = 45.72;
board_dualfeather_screw_y = 42.0;

board_pizero_length = 65;
board_pizero_width = 30;
board_pizero_screw_x = 58;
board_pizero_screw_y = 23;

board_robopico_length = 88;
board_robopico_width = 68;
board_robopico_screw_x = 82;
board_robopico_screw_y = 58;

board_pico_doubler_length = 2.65 * 25.4;
board_pico_doubler_width = 2.05 * 25.4;
board_pico_doubler_screw_x = 2.45 * 25.4;
board_pico_doubler_screw_y = 1.86 * 25.4;

board_pico_length = 56;
board_pico_width = 21;
board_pico_screw_x = 47.1;
board_pico_screw_y = 11.4;

board_rotenc_adafruit_length = 27;
board_rotenc_adafruit_width = 27;
board_rotenc_adafruit_screw_x = 20.5;
board_rotenc_adafruit_screw_y = 20.5;
board_rotenc_adafruit_shaft_dia = 8;
board_rotenc_adafruit_board_to_panel_outer = 10;

board_oled32_length = 1.44 * 25.4;
board_oled32_width = 0.95 * 25.4;
board_oled32_screw_x = 1.10 * 25.4;
board_oled32_screw_y = 0.66 * 25.4;


board_a4988_length = (1.05 * 25.4) + 2;
board_a4988_width = (0.95 * 25.4) + 2;
board_a4988_screw_x = 0.85 * 25.4;
board_a4988_screw_y = 0.58 * 25.4;

board_sparkfun_nav_switch_length = 25;
board_sparkfun_nav_switch_width = 25;
board_sparkfun_nav_switch_screw_x = 20;
board_sparkfun_nav_switch_screw_y = 20;

