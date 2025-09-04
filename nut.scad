/*
 * hex nut generator, from
 * https://github.com/chrisspen/openscad-extra
 */

$fn = 100;

module make_hex_nut(w, h, d=0){
    // d = inner diameter
    // w = width across the flats
    // h = height or thickness
    s = w/sqrt(3);
    
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

//make_hex_nut(w=5, h=2, d=2.5);

module make_nut_2(d=2){
    make_hex_nut(w=4.8, h=2, d=d);
}

