#define itemDraw
/// itemDraw(externalDrawHandle)

var edh;
edh = false;

if (argument_count > 0) {edh = argument[0];}

if (secure_pickup > 0) {secure_pickup--;}
clr();
fnt(fntText);

if (!edh)
{
if (speed > 0)
   {
    speed -= spd_down;  
   }
if (speed < 0) {speed = 0;}

if (!itm_stackable) {show_number = 0;}

if (loot)
{
if (instance_number((drop_id)) > 0)
{
f = (drop_id).open
}

}



if (p == 1)
{
if (loot) {draw_sprite(sRarityEffect,itemRarityEffect(itm_info_color),x-16,y-16);}
if (loot != 2) {if (!drawDrop) {draw_self();} else {draw_item_loot();}}
else {depth = -32; sprite_index = sMask26x26; draw_sprite_ext(sTestItem, realIndex, x + 12, y + 12, 0.75, 0.75, 0, c_white, 0.8);}

if (show_number && loot != 2)
{
alg("center", fntPixelTiny);
draw_text(x+23-16,y+25-16,itm_number);
alg();                                                                                                                   
}
}

if (loot)   
   {   
    if (instance_number((drop_id)) > 0)
      {
      if (f == 1)
       {                                                                                                                       
        p = 1;
       }
      if (f == 0)
           {                                                                                                                    
            p = 0;
           }
      }
      else {p = 1;}
   }

if (hover_info && p == 1)
   {        
     if (distance_to_point(mouse_x,mouse_y) = 0)
        {
         depth = -31;
         if (loot == 2) 
            {
            depth = -32;
            (drop_id).thumbnailImage = realIndex;
            (drop_id).thumbnailPrice = vlastnost[vlastnost_cena];            
            (drop_id).thumbnailCount = itm_number;  
            (drop_id).thumbnailOriginalPrice = vlastnost[vlastnost_originalniCena];
            }
         
         if (instance_number(oItemText) == 0) {i = instance_create(x,y,oItemText); i.parent = (id);}      
         if (mouse_check_button_pressed(mb_left))
            {
            if (on_click)
               {
               if (loot != 2 || (loot == 2 && oPlayer.gold >= vlastnost[vlastnost_cena])) 
               {              
               if (instance_number(oItemText) > 0) {with(oItemText) {instance_destroy();}}
               }
               
               if (object_get_name(object_index) = "oGold") 
                  {
                  oPlayer.gold += itm_number; 
                  instance_destroy(); 
                  if (itm_number < 20)
                  {
                  audio_play_sound(sndCoin,0,0);
                  }
                  else { audio_play_sound(sndCoinPile,0,0);}
                  }
               else 
                    {
                     if (loot != 2) {inventoryPickUp();}
                     else {if (oPlayer.gold >= vlastnost[vlastnost_cena]) {inventoryPickUp(1); audio_play_sound(sndBuyItem, 0, 0); oPlayer.gold -= vlastnost[vlastnost_cena];} else {audio_play_sound(sndError, 0, 0);} if (itm_number == 0) {(drop_id).loot[slot, ext_name] = -1;}}
                     
                   
                    }
                (drop_id).fill[slot] = 0;
               }            
            }
        }
        else 
            {
             depth = -32;
             if (loot == 2) {depth = -32;}
            }
   
   }
   
if (animateDrop)
    {
     direction = animateDropDir;
     image_angle = direction;
     
     speed = animateDropForce;
     animateDropForce = lerp(animateDropForce, 0, 0.02);
     if (animateDropForce <= 0) {animateDrop = false;}
    }
}


#define scrItemImageIndex
/// scrItemImageIndex(itemID)

var n;
n = 1;

if (argument_count > 0) {n = argument[0];}

image_index = n;