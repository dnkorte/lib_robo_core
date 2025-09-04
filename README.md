The files included in this repository are considered "core" files for several of my OpenSCAD robotic projects.  They include items that are supportive of all projects (like dimensions of common parts used, etc).

On the author's computer, these common library files reside in a folder separate from any of the specific project files, and are REFERENCED in those project modules through the use of OpenSCAD include functions for which the path is established through the use of Environment Variables.  In that way I only need one copy of the commonly used files which greatly simplifies maintenance.  

If the user does not expect to have multiple projects accessing those libraries, they may be stored in the project folder containing the 
main module (project file).
  
the core libraries include: 
* core_robo_functions.scad 
* core_config_dimensions.scad
* core_parts_wheels.scad
  
 If they are stored in a location other than the specific project folder (as they are for me), you may use a system ENVIRONMENT
 VARIABLE called OPENSCADPATH to allow OpenSCAD to find them at that location.
 
 to implement the library functionality, setup the environment variable as follows:

 * on linux, store a file called /etc/profile.d/openscadpath.sh with contents:  

 *     export OPENSCADPATH="/home/the_rest_of_the_path/" 

 * (note that ~/.bashrc fails because its not run from terminal session)

 * on Windows, by Control Panel / System / Advanced System Settings / Environment Variables / User Variable 
 
 * see https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries   for more information
