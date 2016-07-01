#define drawAPI
/// drawAPI()
/*

- draw_hover_block(x1,x2,y1,y2,color,alpha)
  
  Used to easily draw rectangle over target area, default is
  yellow rectangle with 0.6 alpha. 
  
- motion_blur(length,direction)

  Creates blur effect after sprite.

-




















#define draw_hover_block
/// draw_hover_block(x1,x2,y1,y2,color,alpha)

x1 = 0;
x2 = 0;
y1 = 0;
y2 = 0;

color = c_yellow;
alpha = 0.6;

if (argument_count > 0) {x1 = argument[0];}
if (argument_count > 1) {x2 = argument[1];}
if (argument_count > 2) {y1 = argument[2];}
if (argument_count > 3) {y2 = argument[3];}

if (argument_count > 4) {color = argument[4];}
if (argument_count > 5) {alpha = argument[5];}



clr(color,alpha);
draw_rectangle(x1,y1,x2-1,y2-1,0);
clr();
#define motion_blur
/// motion_blur(length,direction)
 
   length = argument0;

    if (length > 0) {
        step = 3;
        dir = degtorad(argument1);
        px = cos(dir);
        py = -sin(dir);

        a = image_alpha/(length/step);
        if (a >= 1) {
            draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,
                image_yscale,image_angle,image_blend,image_alpha);
            a /= 2;
        }

        for(i=length;i>=0;i-=step) {
            draw_sprite_ext(sprite_index,image_index,x+(px*i),y+(py*i),
                image_xscale,image_yscale,image_angle,image_blend,a);
        }
    } else {    
        draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,
            image_yscale,image_angle,image_blend,image_alpha);
    }
    return 0;
#define draw_rectangle_cd
/// draw_rectangle_cd(x1, y1, x2, y2, value)

draw_set_colour(c_red);

var v, x1, y1, x2, y2, xm, ym, vd, vx, vy, vl;
v = (argument4 / 360);
if (v <= 0) return 0 
x1 = argument0; y1 = argument1; 
x2 = argument2; y2 = argument3; 
if (v >= 1) return draw_rectangle(x1, y1, x2, y2, false) 
xm = (x1 + x2) / 2; ym = (y1 + y2) / 2;
draw_primitive_begin(pr_trianglefan)
draw_vertex(xm, ym); draw_vertex(xm, y1)


if (v >= 0.125) draw_vertex(x2, y1)
if (v >= 0.375) draw_vertex(x2, y2)
if (v >= 0.625) draw_vertex(x1, y2)
if (v >= 0.875) draw_vertex(x1, y1)

vd = pi * (v * 2 - 0.5)
vx = cos(vd)
vy = sin(vd)

vl = max(abs(vx), abs(vy))
if (vl < 1) {
    vx /= vl
    vy /= vl
}

draw_vertex(xm + vx * (x2 - x1) / 2, ym + vy * (y2 - y1) / 2)
draw_primitive_end()
draw_set_colour(c_black);