#define playerAPI
/// playerAPI()

/*

- apiPlayermove()

  Used to control player movement
  
- apiPlayerMoveStand()

  Stops the player animation when needed

#define apiPlayerMove
/// apiPlayerMove()

apiPlayerRegenerate()

// If nothing blocks player movement ability
if (can_move && can_move2 && can_move3 && can_move4 && can_move5 && can_move6 && !oPlayerCombat.charging) 
    {  
     if (currentAnimation == animationEnum.walk)
        { 
         // Handle IO input
         if (keyboard_check(ord("W"))) {dir = "w"; direction = 90;}     
         if (keyboard_check(ord("S"))) {dir = "s"; direction = 270;}         
         if (keyboard_check(ord("A"))) {dir = "a"; direction = 180;}          
         if (keyboard_check(testKey))  {dir = "d"; direction = 360;}  
        
         /*
         // Parry / block ability
         if (keyboard_check_pressed(ord("N")))
            {
             if (oPlayerCombat.attack = 0 &&  oPlayerCombat.attackMode == "attack" && oPlayer.vlastnost[vlastnost_stamina] >= oPlayer.vlastnost[vlastnost_parry_cost])
                {
                 oPlayerCombat.attackMode              = "parry";
                 oPlayerCombat.parryTimer              = oPlayerCombat.parryTimerMax;
                 oPlayer.vlastnost[vlastnost_stamina] -= oPlayer.vlastnost[vlastnost_parry_cost];
                 oPlayer.parrySlowdown                 = oPlayerCombat.parryTimerSlowdown;
                 oPlayerCombat.parryAngle              = 0;
                }
            }
            
        if (oPlayerCombat.parryTimer > 0)
            {
             oPlayerCombat.parryTimer--;
             if (oPlayerCombat.parryTimer <= 0) {oPlayerCombat.attackMode = "attack"; oPlayer.parrySlowdown = 100;}
            }   
        */
         
        // In case of movement do the common stuff   
        if (keyboard_check(ord("W")) || keyboard_check(ord("S")) || keyboard_check(ord("A")) || keyboard_check(ord("D")))
            {
             a1          = 0
             last_dir    = dir;
             image_speed = (0.25 + (temp_rychlost / 100));
             speed       = temp_rychlost;
             apiPlayerSprint();            
            }      
        
        // In the other case prepare for reseting the animation
        if ((!keyboard_check(ord("W")) && !keyboard_check(ord("S"))  && !keyboard_check(ord("A"))  && !keyboard_check(ord("D"))) && a1 == 0)
            {
             a1           = 1;
             alarm[0]     = 3;
             dir          = "";
             image_speed  = 0;
             speed        = 0;
             image_index  = 12;
            }
    } 
    
    // Stop animation when cutscene starts
    if (!can_move && currentAnimation == animationEnum.walk)
        {
         dir = "s" 
         image_index = 12;
        }
     
    // Adjust animation phase cycle     
    if (currentAnimation != animationEnum.bash)
       {  
        if (dir == "w") {if (image_index < 0  || image_index > 5.9)  {image_index = 0;}}
        if (dir == "s") {if (image_index < 12 || image_index > 17.9) {image_index = 12;}}    
        if (dir == "a") {if (image_index < 6  || image_index > 11.9) {image_index = 6;}}    
        if (dir == "d") {if (image_index < 18 || image_index > 23.9) {image_index = 18;}}        
       }    
    }    
    
// Compute temp speed
temp_rychlost = ((rychlost / 100) * parrySlowdown) * (1 - slowdown);    
time         += 0.02;;    

// Update pulse speed of FOV
heartBeat = (0.004 - ((oPlayer.last_hp / apiPlayerGetPropertyValue(vlastnost_max_zivot)) / 250));
scrSimpleLightUpdate(0, -1, -1, -1, -1, -1, -1, -1, heartBeat);


#define apiPlayerMoveStand
/// apiPlayerMoveStand()

math_set_epsilon(0.0001);

// Choose idle frame from the animation based on direction
if (currentAnimation == animationEnum.walk)
    {
     if (image_index > 12 && image_index < 17.99) {image_index = 12;} 
     if (image_index > 0  && image_index < 5.99)  {image_index = 0;} 
     if (image_index > 6  && image_index < 11.99) {image_index = 6;}     
     if (image_index > 18 && image_index < 23.99) {image_index = 18;} 
    }

#define apiPlayerSprint
/// apiPlayerSprint()

// Drain stamina and spawn particles. Also stop sprinting in case of insufficient stamina.
if (keyboard_check(vk_shift))       
    {
     if (vlastnost[vlastnost_stamina] > 0) {vlastnost[vlastnost_stamina] -= 0.1; speed += 1; sprinting = true;}
     else {sprinting = false;} 
     
     // Splash particles
     if (sprinting)
        {
         if (dir == "w") {effectSprint(x, y + 24);}
         else if (dir == "s") {effectSprint();}
         else if (dir == "a") {effectSprint(x, y + 24);}
         else if (dir == "d") {effectSprint(x, y + 24);}
        }
    }
else 
    {
     sprinting = 0;
    }


#define apiPlayerRegenerate
/// apiPlayerRegenerate()

// Handle timer and heal on tick
if (stamina_tick > 0 && !sprinting) {stamina_tick --;}
else
    {
    if (!sprinting)
        {
         stamina_tick                  = apiPlayerGetPropertyValue(vlastnost_tick_stamina, false, true);
         vlastnost[vlastnost_stamina] += apiPlayerGetPropertyValue(vlastnost_tick_stamina_add, false, true);
        }
    }

#define apiPlayerDraw
/// apiPlayerDraw()

// Draw body canvas
for (i = 0; i < 15; i++)
    {
     if (bci[currentAnimation, i] != 0 && bci[currentAnimation, i] != sCatchError) {draw_sprite(bci[currentAnimation, i], image_index, x, y);} 
    }

// In case of attack, spell cast or other special action flow the animation    
if (currentAnimation != animationEnum.walk && currentAnimation != animationEnum.die && currentAnimation != animationEnum.bash)
    {
     animationEnd  = false;
     lastAnimation = currentAnimation;
     image_speed   = animationSpeed[currentAnimation];
        
     if (last_dir == "s" || last_dir == "") {if (image_index > 17)  {animationEnd = true; sprite_index  = bci[0, 0]; currentAnimation = animationEnum.walk; image_index = 12; image_speed = 0;}}
     if (last_dir == "d")                   {if (image_index >= 23) {animationEnd = true; sprite_index  = bci[0, 0]; currentAnimation = animationEnum.walk; image_index = 18; image_speed = 0;}}
     if (last_dir == "a")                   {if (image_index >= 11) {animationEnd = true; sprite_index  = bci[0, 0]; currentAnimation = animationEnum.walk; image_index = 6;  image_speed = 0;}}
     if (last_dir == "w")                   {if (image_index >= 5)  {animationEnd = true; sprite_index  = bci[0, 0]; currentAnimation = animationEnum.walk; image_index = 0;  image_speed = 0;}}
    
     if (animationEnd)
        {         
         if (lastAnimation == animationEnum.fire)
            {
             var i = instance_create(oPlayerCombat.x + 24, oPlayerCombat.y + 24, oProjectile); 
               i.speed = 7; 
               i.dmg = 10; 
               i.maxSpd = 20; 
               if (oPlayer.last_dir == "d") {i.direction = 0;}
               if (oPlayer.last_dir == "a") {i.direction = 180;}
               if (oPlayer.last_dir == "w") {i.direction = 90;}
               if (oPlayer.last_dir == "s") {i.direction = 270;}
               i.image_angle = i.direction;    
               oInventory.equiped_stats[5, inv_number]--;    
               audio_play_sound(sndArrow, 0, false);                
            }
        }
    }
    
if (currentAnimation == animationEnum.die)
   {
    image_speed = animationSpeed[currentAnimation];    
    if (image_index >= 5) {image_index = 5;}           
   }  
   
if (currentAnimation == animationEnum.bash)
   {
    image_speed = animationSpeed[currentAnimation];    
    if (image_index >= 8) {sprite_index = bci[0, 0]; currentAnimation = animationEnum.walk; image_index = 0;  image_speed = 0;}           
   }      

// Update vars - lineary interpolate to real values
stamina_dif = abs(last_stamina - vlastnost[vlastnost_stamina]);
health_dif  = abs(last_hp      - vlastnost[vlastnost_zivot]);

if (stamina_dif <= 5) {stamina_bar = 0.1;}
if (health_dif  <= 5) {health_bar = 0.1;}
else {health_bar = 1;} 
     
last_hp      = lerp(last_hp,       apiPlayerGetPropertyValue(vlastnost_zivot, false, true),      0.1);
last_stit    = lerp(last_stit,     apiPlayerGetPropertyValue(vlastnost_stit, false, true),       0.1);
last_mana    = lerp(last_mana,     apiPlayerGetPropertyValue(vlastnost_mana, false, true),       0.1);
last_stamina = lerp(last_stamina,  apiPlayerGetPropertyValue(vlastnost_stamina, false, true),    0.1);
last_xp      = round(lerp(last_xp, apiPlayerGetPropertyValue(vlastnost_zkusenosti, false, true), 0.1));

// Handle speech queue
if (ds_queue_size(speechQueue) > 0)
    {
     if (!speechIn)
        {
         speechCurrentText = ds_queue_dequeue(speechQueue);
         speechIn = true;         
        }
    }
    
if (speechIn)
    {
     if (speechMode == 0) {speechAlpha = lerp(speechAlpha, 1.1, 0.1); if (speechAlpha >= 1) {speechMode = 1; speechTimer = 100;}}
     if (speechMode == 1) {speechTimer--; if (speechTimer <= 0) {speechMode = 2;}}
     if (speechMode == 2) {speechAlpha = lerp(speechAlpha, -0.1, 0.1); if (speechAlpha <= 0) {speechMode = 0; speechIn = false; speechTimer = 100;}}
     
     fnt();
     clr (c_black, speechAlpha / 2);
     var yDec = 0;
     if (string_height(speechCurrentText) > 32) {yDec = 24;}
     
     draw_roundrect_colour_ext(x - string_width(speechCurrentText) / 2 - 10,y - 48 - yDec,x + string_width(speechCurrentText) / 2+10,y+string_height(speechCurrentText)+2-48-yDec,20,20,c_black,c_black,0);
     clr(c_white, speechAlpha);
     draw_text(x - string_width(speechCurrentText) / 2, y - 48 - yDec, speechCurrentText);
     clr();
     
     if (speechSkip)
        {
         if (ds_queue_size(speechQueue) > 0) {speechSkip = false; speechIn = false;}
        }
     }


// Decrease spells colldowns      
for (a = 0; a < spell_total; a++)
    {
     if (spell_cd[a] > 0) {spell_cd[a]--;}
    }                




#define apiPlayerUnstuck
/// apiPlayerUnstuck()

with(oPlayer)
{
if (!place_empty(x, y))
{
tX = x;
tY = y;

// Get distances
while(!place_empty(tX, tY)) {tX--;}
dis[0] = abs(x - tX);

tX = x;
tY = y;    

while(!place_empty(tX, tY)) {tX++;}
dis[1] = abs(x - tX);

tX = x;
tY = y;    

while(!place_empty(tX, tY)) {tY++;}
dis[2] = abs(y - tY);

tX = x;
tY = y;    

while(!place_empty(tX, tY)) {tY--;}
dis[3] = abs(y - tY);

// Get min distance and prioritize last direction
minDistance   = min(dis[0], dis[1], dis[2], dis[3]);
deltaDistance = 0;

if (last_dir == "s") {deltaDistance = dis[2];}
if (last_dir == "w") {deltaDistance = dis[3];}
if (last_dir == "d") {deltaDistance = dis[1];}
if (last_dir == "a") {deltaDistance = dis[0];}

difDistance = abs(deltaDistance - minDistance);

if (difDistance < 3) 
    {
     if (last_dir == "s") {y += dis[2];}
     if (last_dir == "w") {y -= dis[3];}
     if (last_dir == "d") {x += dis[1];}
     if (last_dir == "a") {x -= dis[0];}     
    }
else
    {
     for (i = 0; i < 3; i++)
        {
         if (minDistance == dis[i])
            {
             if (i == 0) {x -= dis[i];}
             if (i == 1) {x += dis[i];}
             if (i == 2) {y += dis[i];}
             if (i == 3) {y -= dis[i];}             
            }
        }
    }
}
}
#define apiPlayerGetProperty
/// apiPlayerGetProperty(index)

var index, text, cbu, hint, ut;
index = 0;
text  = "";
cbu   = true;
hint  = "";
ut    = 0;

if (argument_count > 0) {index = argument[0];}

 switch(index)
                    {
                    case(vlastnost_bonusove_poskozeni_vuci_zviratum):
                         {
                           text = "Poškození vůči zvířatům";
                           cbu  = false;
                           ut   = 1000;
                           break;                                                                   
                         }
                    case(vlastnost_bonusoveZkusenosti):
                         {
                           text = "Bonusové zkušenosti";
                           cbu  = false;
                           ut   = 1000;
                           break;                                                                   
                         }
                    
                    case(vlastnost_stackSezehnuti):
                         {
                           text = "Šance na sežehnutí";
                           cbu  = false;
                           ut   = 1000;
                           break;                                                                   
                         }
                     case(vlastnost_poskozeni):
                         {
                           text = "Poškození";
                           cbu  = false;
                           break;                                                                   
                         }
                     case(vlastnost_max_zivot):
                         {
                           text = "Život";
                           cbu  = false;
                           break;                                                                   
                         }
                     case(vlastnost_stamina_cost):
                         {
                           text = "Stamina za úder";
                           cbu  = false;
                           break;                                                                   
                         }
                    case(vlastnost_max_mana):
                         {
                           text = "Mana"; 
                           cbu  = false;                          
                           break;                                                                   
                         }
                    case(vlastnost_sila):
                         {
                           text = "Síla";
                           hint = "Síla zvyšuje tvé fyzické poškození.";
                           break;                                                                   
                         }
                    case(vlastnost_obratnost):
                         {
                           text = "Obratnost";
                           hint = "Zvyšuje šanci na vyhnutí se útoku.";
                           break;                                                                   
                         }
                    case(vlastnost_kovarstvi):
                         {
                           text = "Kovářství";
                           hint = "Odhaluje dávné znalosti o zpracování kovů a jejich využití.";
                           ut   = 1;
                           break;                                                                   
                         }
                    case(vlastnost_tezarstvi):
                         {
                           text = "Těžařství";
                           ut   = 1;
                           break;                                                                   
                         }    
                    case(vlastnost_alchymie):
                         {
                           text = "Alchymie";
                           ut   = 1;
                           break;                                                                   
                         }                 
                    case(vlastnost_odolnost):
                         {
                           text = "Odolnost";
                           hint = "Činí tvé tělo odolnějším, dokážeš snést více ran, než zemřeš.";

                           break;                                                                   
                         }
                    case(vlastnost_vytrvalost):
                         {
                           text = "Vytrvalost";
                           hint = "Zvyšuje tvoji výdrž, prodlužuje dobu, po kterou dokážeš běžet.";
                           break;                                                                   
                         }
                     case(vlastnost_presnost):
                         {
                           text = "Přesnost";
                           hint = "Tvé údery nikdy neminou cíl a mají šanci najít na protivníkovi zranitelné místo.";
                           break;                                                                   
                         }
                     case(vlastnost_rychlost):
                         {
                           text = "Rychlost";
                           ut   = 666;
                           break;                                                                   
                         }
                    case(vlastnost_zrucnost):
                         {
                           text = "Zručnost";
                           hint = "Umožňuje ti vytvářet mocnější předměty.";
                           break;                                                                   
                         }
                    case(vlastnost_stesti):
                        {
                           text = "Štěstí";
                           hint = "Najdeš více předmětů a zlata. Také se na tebe občas usměje Foruna.";                       
                           break;
                        }
                    case(vlastnost_svadeni):
                         {
                           text = "Svádění";
                           ut   = 2;
                           break;                                                                   
                         }
                    case(vlastnost_zastrasovani):
                         {
                           text = "Zastrašování";
                           ut   = 2;
                           break;                                                                   
                         }
                    case(vlastnost_dustojnost):
                         {
                           text = "Důstojnost";
                           ut   = 2;
                           break;                                                                   
                         }
                    case(vlastnost_vyrecnost):
                         {
                           text = "Výřečnost";
                           ut   = 2;
                           break;                                                                   
                         }
                    case(vlastnost_elegance):
                         {
                           text = "Elegance";
                           ut   = 2;
                           break;                                                                   
                         }
                    case(vlastnost_cest):
                         {
                           text = "Čest";
                           ut   = 4;
                           break;                                                                   
                         }
                         
                    case(vlastnost_kapsarstvi):
                         {
                           text = "Kapsářství";
                           ut   = 4;
                           break;                                                                   
                         }
                     case(vlastnost_paceni_zanmku):
                         {
                           text = "Páčení zámků";
                           ut   = 4;
                           break;                                                                   
                         }
                     case(vlastnost_vule):
                         {
                           text = "Vůle";
                           ut   = 3;
                           break;                                                                   
                         }
                    case(vlastnost_inteligence):
                         {
                           text = "Inteligence";
                           hint = "Zvyšuje účinky tvých kouzel a zásobu many.";
                           break;                                                                   
                         }
                    case(vlastnost_ritualy):
                         {
                           text = "Rituály";
                           ut   = 3;
                           break;                                                                   
                         }
                    case(vlastnost_tradicni_magie):
                         {
                           text = "Tradiční magie";
                           ut   = 3;
                           break;                                                                   
                         }
                    case(vlastnost_astralni_videni):
                         {
                           text = "Astrální vidění";
                           ut   = 3;
                           break;                                                                   
                         }
                    case(vlastnost_mece):
                         {
                           text = "Meče";
                           ut   = 5
                           break;                                                                   
                         }
                    case(vlastnost_dyky):
                         {
                           text = "Dýky";
                           ut   = 5;
                           break;                                                                   
                         }
                    case(vlastnost_luky):
                         {
                           text = "Lukostřelba";
                           ut   = 5;
                           break;                                                                   
                         }
                     case(vlastnost_kopi):
                         {
                           text = "Kopí";
                           ut   = 5;
                           break;                                                                   
                         }
                     case(vlastnost_jednorucni):
                         {
                           text = "Jednoruční zbraně";
                           ut   = 5;
                           break;                                                                   
                         }
                    case(vlastnost_dvojrucni):
                         {
                           text = "Dvojruční zbraně";
                           ut   = 5;
                           break;                                                                   
                         }
                    case(vlastnost_stity):
                         {
                           text = "Štíty";
                           ut   = 5;
                           break;                                                                   
                         }
                    case(vlastnost_rezistence_vse):
                         {
                           text = "Obecná ochrana vůči poškození";
                           cbu  = false;
                           ut   = 667;
                           break;                                                                   
                         }
                    case(vlastnost_rezistence_zeme):
                         {
                           text = "Země";
                           cbu  = false;
                           ut   = 666;
                           break;                                                                   
                         }
                    case(vlastnost_rezistence_ohen):
                         {
                           text = "Oheň";
                           cbu  = false;
                           ut   = 666;
                           break;                                                                   
                         }
                    case(vlastnost_rezistence_voda):
                         {
                           text = "Voda";
                           cbu  = false;
                           ut   = 666;
                           break;                                                                   
                         }
                    case(vlastnost_rezistence_temnota):
                         {
                           text = "Temnota";
                           cbu  = false;
                           ut   = 666;
                           break;                                                                   
                         }
                         
                     case(vlastnost_rezistence_svetlo):
                         {
                           text = "Světlo";
                           cbu  = false;
                           ut   = 666;
                           break;                                                                   
                         }
                    case(vlastnost_rezistence_vitr):
                         {
                           text = "Vítr";
                           cbu  = false;
                           ut   = 666;
                           break;                                                                   
                         }
                    case(vlastnost_zivot):
                         {
                           text = "Zdraví";
                           cbu  = false;
                           break;                                                                   
                         }
                    case(vlastnost_mana):
                         {
                           text = "Mana";
                           cbu  = false;
                           break;                                                                   
                         }
                    case(vlastnost_stamina):
                         {
                           text = "Stamina";
                           cbu  = false;
                           break;                                                                   
                         }
                         
                    case(vlastnost_max_stamina):
                         {
                           text = "Stamina";
                           cbu  = false;
                           break;                                                                   
                         }
                    case(vlastnost_kriticka_sance):
                         {
                           text = "Šance na kritický úder";
                           cbu  = false;
                           break;                                                                   
                         }
                    case(vlastnost_kriticka_nasobic):
                         {
                           text = "Násobitel kritického úderu";
                           cbu  = false;
                           break;                                                                   
                         }
                    case(vlastnost_stit):
                         {
                           text = "Štít";
                           cbu  = false;
                           break;                                                                   
                         }
                    case(vlastnost_max_stit):
                         {
                           text = "Štít";
                           cbu  = false;
                           break;                                                                   
                         }
                    case(vlastnost_zkusenosti):
                         {
                           text = "Zkušenosti";
                           cbu  = false;
                           break;                                                                   
                         }
                    case(vlastnost_max_zkusenosti):
                         {
                           text = "Zkušenosti potřebné k dosažení další úrovně";
                           cbu  = false;
                           break;                                                                   
                         }
                    case(vlastnost_level):
                         {
                           text = "Úroveň hrdiny";
                           cbu  = false;
                           break;                                                                   
                         }
                    case(vlastnost_tick_stamina):
                         {
                           text = "Rychlost regenerace staminy";
                           cbu  = false;
                           break;                                                                   
                         }
                    case(vlastnost_tick_stamina_add):
                         {
                           text = "Množství obnovené staminy";
                           cbu  = false;
                           break;                                                                   
                         }
                         
                    
}

returnedArray[0] = text;
returnedArray[1] = cbu;
returnedArray[2] = ut;
returnedArray[3] = hint;

if (returnedArray[0] != "") {return true;} else {return false;}

#define apiPlayerUpdateProperties
/// apiPlayerUpdateProperties()

// Atributes
oPlayer.maxHp = (apiPlayerGetPropertyValue(vlastnost_max_zivot, false, true) + apiPlayerGetPropertyValue(vlastnost_odolnost, false, true) * oStatusMenu.incHealth);  
oPlayer.maxMp = (apiPlayerGetPropertyValue(vlastnost_max_mana, false, true)  + apiPlayerGetPropertyValue(vlastnost_inteligence, false, true) * oStatusMenu.incMana);  

// Clamp vars to bounds
oPlayer.vlastnost[vlastnost_zivot]   = clamp(apiPlayerGetPropertyValue(vlastnost_zivot, false, true),   0, oPlayer.maxHp);
oPlayer.vlastnost[vlastnost_mana]    = clamp(apiPlayerGetPropertyValue(vlastnost_mana, false, true),    0, oPlayer.maxMp);
oPlayer.vlastnost[vlastnost_stamina] = clamp(apiPlayerGetPropertyValue(vlastnost_stamina, false, true), 0, apiPlayerGetPropertyValue(vlastnost_max_stamina, false, true));
oPlayer.vlastnost[vlastnost_stit]    = clamp(apiPlayerGetPropertyValue(vlastnost_stit, false, true),    0, apiPlayerGetPropertyValue(vlastnost_max_stit, false, true));

// Check for lvl-up / death
if (oPlayer.last_hp < 0) {oPlayer.last_hp = 0;}
if (oPlayer.last_xp >= oPlayer.vlastnost[vlastnost_max_zkusenosti]) {apiPlayerLevelUp();}




#define apiPlayerGetXP
/// apiPlayerGetXP(value, allowBonusXP)

var value, abxp;
value = 0;
abxp  = true;

if (argument_count > 0) {value = argument[0];}
if (argument_count > 1) {abxp  = argument[1];}

if (abxp) {value = value + (value * (oPlayer.vlastnost[vlastnost_bonusoveZkusenosti] / 100));}
oPlayer.vlastnost[vlastnost_zkusenosti] += value;

return(round(value));
#define apiPlayerReverseState
/// apiPlayerReverseState()

if (oPlayer.last_dir == "a") {oPlayer.image_index = 6;}
if (oPlayer.last_dir == "d") {oPlayer.image_index = 18;}
if (oPlayer.last_dir == "w") {oPlayer.image_index = 0;}
if (oPlayer.last_dir == "s") {oPlayer.image_index = 12;}

#define apiPlayerSay
/// apiPlayerSay(text, [onlyOnEmptyFront], mode, callID)

var t, o, m, d;
t = "Sample text";
o = false;
m = "";
d = -1;

if (argument_count > 0) {t = argument[0];}
if (argument_count > 1) {o = argument[1];}
if (argument_count > 2) {m = argument[2];}
if (argument_count > 3) {d = argument[3];}

if (m == "")
   {
    if (o) {if (ds_queue_size(oPlayer.speechQueue) > 0 || oPlayer.speechAlpha > 0.02) {return false;}}

    ds_queue_enqueue(oPlayer.speechQueue, t);
    return true;
   }

if (m == "combat")
   {
    if (d == oEnemySlime) {text = choose("Seber nohy na ramena!#Ah, ty žádné nemáš.");}
    else if (d == oBunny) {text = choose("Kralík na smetaně!");} 
    else {text = "";}
    
    ds_queue_enqueue(oPlayer.speechQueue, text);
   }

#define apiPlayerSayNext
/// apiPlayerSayNext()

if (ds_queue_size(oPlayer.speechQueue) > 0)
    {
     oPlayer.speechSkip = true;
    }
#define apiPlayerGetRankName
/// apiPlayerGetRankName()

return oPlayer.rankName[oPlayer.vlastnost[vlastnost_level]];

#define apiPlayerGetMana
/// apiPlayerGetMana(value)

var v;
v = 0;

if (argument_count > 0) {v = argument[0];}

oPlayer.vlastnost[vlastnost_mana] +=  v;

return(v);

#define apiPlayerGetDamage
/// apiPlayerGetDamage(damage, damageType, elementType, goreSound, destroySelf, logDmg, stateLog)

var d, t, e, deltaD, q, modQ, minQ, g, s, l, z;
d = 0;
t = damageEnum.damageNormal;
e = elementEnum.elementNone;
g = sndPoo;
s = false;
l = true;
z = "";

if (argument_count > 0) {d = argument[0];}
if (argument_count > 1) {t = argument[1];}
if (argument_count > 2) {d = argument[2];}
if (argument_count > 3) {g = argument[3];}
if (argument_count > 4) {s = argument[4];}
if (argument_count > 5) {l = argument[5];}
if (argument_count > 6) {z = argument[6];}
d = dmg;

// Decrese dmg by def 
/* To fully cover dmg we need (dmg * 3) armor
   In that case, pass 1 + {0, r(dmg / 5)) dmg
*/
deltaD = (d - round(d - (oPlayer.vlastnost[vlastnost_odolnost] / 3)));
if (deltaD >= d)
    {
   //  d = irandom_range(1, irandom(d / 5));
    } 
else
    {
   //  d -= deltaD;
    }

// Compute max shield absorbtion
q    = oPlayer.vlastnost[vlastnost_stit];
maxQ = 0; // Max dmg amount to be absorbed
modQ = 0; // Rest of dmg

if (t == damageEnum.damagePhysical)         {maxQ = d;            modQ = 0;}
else if (t == damageEnum.damageNormal)      {maxQ = round(d / 2); modQ = maxQ;}
else if (t == damageEnum.damagePenetration) {maxQ = round(d / 4); modQ = (maxQ * 3);}
else if (t == damageEnum.damageTrue)        {maxQ = 0;            modQ = d;}

// If we don't have enough shield to fully absorb dmg
if (q < maxQ)
    {
     if (q >= 1)
     {
     maxQ -= q;
     modQ += q;
     }
     else 
     {
     maxQ = 0;
     modQ = d;
     }
    }

// Finally decrease stats
oPlayer.vlastnost[vlastnost_zivot] -= modQ;
oPlayer.vlastnost[vlastnost_stit]  -= maxQ;

// Spawn blood
//   - gore
if (modQ > 0)
{
scrGoreMed(oPlayer.x, oPlayer.y, irandom_range(2, 3));
audio_play_sound(g, 0, false);

} 

//   - armor shards
if (maxQ > 0)
{
audio_play_sound(choose(sndArmor1, sndArmor2, sndArmor3, sndArmor4), 0, false);
}

// Log
if (l) {scrLog(string(dmg),c_black,-1,0,0,oPlayer.x,oPlayer.y-48,fntPixelHuge);}
if (z != "") {stateAddEntry(z);}

// Destroy self
if (s) {instance_destroy();}

#define apiPlayerGetShield
/// apiPlayerGetShield(value)

var v;
v = 0;

if (argument_count > 0) {v = argument[0];}

oPlayer.vlastnost[vlastnost_stit] +=  v;

return(v);
#define apiPlayerGetSpeechSize
/// apiPlayerGetSpeechSize()

return ds_queue_size(oPlayer.speechQueue);
#define apiPlayerIni
/// apiPlayerIni(health, mana, stamina, shield, level)

vlastnost[vlastnost_max_zivot]      = 40;
vlastnost[vlastnost_max_stit]       = 10;
vlastnost[vlastnost_max_stamina]    = 15;
vlastnost[vlastnost_max_mana]       = 50;
vlastnost[vlastnost_level]          = 1;

if (argument_count > 0) {vlastnost[vlastnost_max_zivot]   = argument[0];}
if (argument_count > 1) {vlastnost[vlastnost_max_mana]    = argument[1];}
if (argument_count > 2) {vlastnost[vlastnost_max_stamina] = argument[2];}
if (argument_count > 3) {vlastnost[vlastnost_max_stit]    = argument[3];}
if (argument_count > 3) {vlastnost[vlastnost_level]       = argument[4];}

vlastnost[vlastnost_zivot]   = vlastnost[vlastnost_max_zivot];
vlastnost[vlastnost_stit]    = vlastnost[vlastnost_max_stit];
vlastnost[vlastnost_stamina] = vlastnost[vlastnost_max_stamina];
vlastnost[vlastnost_stit]    = vlastnost[vlastnost_max_stit];
vlastnost[vlastnost_mana]    = vlastnost[vlastnost_max_mana];

last_hp      = vlastnost[vlastnost_zivot];
last_stit    = vlastnost[vlastnost_stit];
last_stamina = vlastnost[vlastnost_stamina];
last_mana    = vlastnost[vlastnost_mana];
last_xp      = 0;

vlastnost[vlastnost_zkusenosti]     = 0;
vlastnost[vlastnost_max_zkusenosti] = 100;

#define apiPlayerSetMaxExp
/// apiPlayerSetMaxExp()

oPlayer.vlastnost[vlastnost_max_zkusenosti] = round(oPlayer.vlastnost[vlastnost_zkusenosti] + log2(oPlayer.vlastnost[vlastnost_zkusenosti]) + oPlayer.vlastnost[vlastnost_zkusenosti] / 3);


#define apiPlayerLevelUp
/// apiPlayerLevelUp()

var inst;

apiPlayerSetMaxExp();
oPlayer.vlastnost[vlastnost_zkusenosti]     = 0;
oPlayer.last_xp                             = 0;
oPlayer.vlastnost[vlastnost_level]++; 
oPlayer.skillPoints++;
oPlayer.talentPoints++;

inst            = instance_create(view_xview, view_yview, oAchievement);
inst.header     = "Úroveň " + string(oPlayer.vlastnost[vlastnost_level]) + " dosažena!";
inst.text       = "Nyní jsi znám jako " + scrColorflag(c_yellow) + apiPlayerGetRankName() + scrEndColorflag()+ ".";
inst.index      = 0;
inst.medalType  = 2;

audio_play_sound(sndSoundLevelUp, 1, false);

#define apiPlayerOtherActions
/// apiPlayerOtherActions()

// Game save & load
if (keyboard_check_pressed(vk_numpad7)) {scrGameSave();}
if (keyboard_check_pressed(vk_numpad8)) {scrGameLoad();}

// Pause game    
if (keyboard_check_pressed(vk_escape)) {scrPauseGame();}

// Hide HUD [TEMP]
if (keyboard_check_pressed(ord("Y"))) {oHUD.draw = !oHUD.draw}

#define apiPlayerSpellCast
/// apiPlayerSpellCast(index, [returnIndex])

with(oPlayer)
{
var index, r;
index = 0;
r     = false;

if (argument_count > 0) {index = argument[0];}
if (argument_count > 1) {r     = argument[1];}

if (r)
   {
    for (var i = 0; i < spell_total; i++)
        {
         if (oHUD.hotslot[index, 3] == oSpellMenu.spellSprite[i]) {return i;}
        }
   }

if (oHUD.hotslot[index, 3] == sSpellFireball)
   {
    if (vlastnost[vlastnost_mana] >= magic[spell_fireball_cost] && spell_cd[SpellEnum.spellFireball] = 0) {spell_cd[SpellEnum.spellFireball] = magic[spell_fireball_cooldown]; temp_cd[SpellEnum.spellFireball] = spell_cd[SpellEnum.spellFireball]; vlastnost[vlastnost_mana] -= magic[spell_fireball_cost]; i = instance_create(x,y,oBasicSpell); i.type = "fireball";}
   }
else if (oHUD.hotslot[index, 3] == sSpellFrozenBolts)
   {
    if (vlastnost[vlastnost_mana] >= magic[spell_frozen_bolts_cost] && spell_cd[SpellEnum.spellFrozenBolts] = 0) {spell_cd[SpellEnum.spellFrozenBolts] = magic[spell_frozen_bolts_cooldown]; temp_cd[SpellEnum.spellFrozenBolts] = spell_cd[SpellEnum.spellFrozenBolts]; vlastnost[vlastnost_mana] -= magic[spell_frozen_bolts_cost]; magic_repeat = magic[spell_frozen_bolts_number]; i = instance_create(x,y,oBasicSpell); i.type = "frozen_bolt"; alarm[1] = random_range(5,8); magic_timer = random_range(2,4); magic_id = "frozen_bolt"; can_move3 = 0; speed = 0; image_speed = 0;}
   }
else if (oHUD.hotslot[index, 3] == sSpellFireBeam)
   {
    if (vlastnost[vlastnost_mana] >= magic[spell_fire_trail_cost] && spell_cd[SpellEnum.spellFireBeam] = 0) {if (instance_number(oLenghdirSpell) = 0 && (dir != "" || last_dir != "")) {i = instance_create(x,y,oLenghdirSpell); i.dir = last_dir; i.type = "fire_trail"; i.index = SpellEnum.spellFireBeam; can_move3 = 0; speed = 0; image_speed = 0; vlastnost[vlastnost_mana] -= magic[spell_fire_trail_cost];} else {if (oLenghdirSpell.alarm[1] < 2) {vlastnost[vlastnost_mana] -= magic[spell_fire_trail_cost]; oLenghdirSpell.alarm[1] = 20;} }   }
   }
else if (oHUD.hotslot[index, 3] == sSpellFlash)
   {
    if (vlastnost[vlastnost_mana] >= magic[spell_flash_cost] && spell_cd[SpellEnum.spellFlash] == 0) {spell_cd[SpellEnum.spellFlash] = magic[spell_flash_cooldown];  temp_cd[SpellEnum.spellFlash] = spell_cd[SpellEnum.spellFlash]; vlastnost[vlastnost_mana] -= magic[spell_flash_cost]; tempI = 0; if (last_dir = "d") {repeat(96/8) {effectShodowPort(x + tempI, y, 1); tempI += 8;} x += 96;} if (last_dir = "a") {repeat(96/8) {effectShodowPort(x - tempI, y, 1); tempI += 8;} x -= 96;} if (last_dir = "w") {repeat(96/8) {effectShodowPort(x, y - tempI, 1); tempI += 8;} y -= 96;} if (last_dir = "s") {repeat(96/8) {effectShodowPort(x, y + tempI, 1); tempI += 8;} y += 96;} scrEnemyApplyAffect("flash", 120, 1, c_lime, 1, 100, true, false, false);  }
   }
else if (oHUD.hotslot[index, 3] == sSpellVines)
   {
    if (vlastnost[vlastnost_mana] >= magic[spell_vines_cost] && spell_cd[SpellEnum.spellVines] = 0) {spell_cd[SpellEnum.spellVines] = magic[spell_vines_cooldown]; temp_cd[SpellEnum.spellVines] = spell_cd[SpellEnum.spellVines]; vlastnost[vlastnost_mana] -= magic[spell_vines_cost]; tempI = 0; i = instance_create(x,y,oBasicSpell); i.type = "vines";}
   }
}

#define apiPlayerSetMagic
/// apiPlayerSetMagic(index, value)

var i, v;
i = 0;
v = 0;

if (argument_count > 0) {i = argument[0];}
if (argument_count > 1) {v = argument[1];}

oPlayer.magic[i] = v;

#define apiPlayerCreate
/// apiPlayerCreate()


// Set base vars
Sname                 = part_system_create();
z                     = 0;
blur                  = 0;
load                  = 1;
dir                   = ""; 
h1                    = 0;
rychlost              = 3.5; 
can_move              = 1;
can_move2             = 1;
can_move3             = 1;
can_move4             = 1;
can_move5             = 1;
can_move6             = 1;
a1                    = 0;
last_dir              = "s";
cyber_r               = 0;
attack_interval       = 40;
m1                    = 0;
m2                    = 0;
can_damage            = -1;
tempN                 = 0;
text                  = "";
parrySlowdown         = 100;
temp_rychlost         = rychlost;
slowdown              = 0;
equ_draw_head         = 1;
equ_draw_left_plate   = 1;
egu_draw_right_plate  = 1;
equ_draw_body         = 1;
equ_draw_right_hand   = 1;
equ_draw_left_hand    = 1;
equ_draw_left_ring1   = 1;
equ_draw_left_ring2   = 1;
equ_draw_right_ring1  = 1;
equ_draw_right_ring2  = 1;
equ_draw_crown        = 1;
equ_draw_trophy1      = 1;
equ_draw_trophy2      = 1;
equ_draw_trophy3      = 1;
equ_draw_special1     = 1;
equ_draw_special2     = 1;
equ_draw_belt         = 1;
equ_draw_left_boot    = 1;
equ_draw_right_boot   = 1;
gold                  = 0;
sprinting             = false;
magic_repeat          = 0;
magic_timer           = 1;
magic_id              = "";
spell[0]              = "";
spell[1]              = "";
spell[2]              = "";
spell_cd[0]           = 0;
spell_cd[1]           = 0;
spell_cd[2]           = 0;
temp_cd[0]            = 1;
temp_cd[1]            = 1;
temp_cd[2]            = 1;
spell_sprite[0]       = sFreeSlot;
spell_sprite[1]       = sFreeSlot;
spell_sprite[2]       = sFreeSlot;
spell_index           = -1; 
speechQueue           = ds_queue_create();
speechAlpha           = 0;
speechIn              = false;
speechCurrentText     = "";
speechMode            = 0;
speechSkip            = false;
last_mp               = 0;
inFight               = false;
weaponType            = "";
rarityTick            = 20;
dead                  = false;
dieTimer              = 0;
heartBeat             = 0.001;
weaponType2           = "";

set_sprite(sprite_index, 0);

for(a = 0; a < celkem_vlastnosti; a++)
{
 vlastnost[a]       = 0;
 vlastnostStatic[a] = 0;
}

for(a = 0; a < spell_total; a++)
{
 magic[a]    = 0;
 spell_cd[a] = 0; 
}

// Create needed objects
instantiate(oPlayerCombat);
instantiate(oState);
instantiate(oHUD);
instantiate(oOptimize);
instantiate(oMinimap);
instantiate(oDayNight);
instantiate(oInventory);

scrAffectsIni();
apiPlayerUpdateKeysFromConfig();

// Rank names
rankName[1]  = "cizinec";
rankName[2]  = "návštěvník";
rankName[3]  = "neznámý cestovatel";
rankName[4]  = "bezejmenný kupec";
rankName[5]  = "stálý návštěvník";
rankName[6]  = "povědomá tvář";
rankName[7]  = "známý poutník";
rankName[8]  = "vzácný host";
rankName[9]  = "přítel města";
rankName[10] = "zmocněnec královského písaře";

maxHp = (vlastnost[vlastnost_max_zivot] + vlastnost[vlastnost_odolnost] * 5);
maxMp = (vlastnost[vlastnost_max_zivot] + vlastnost[vlastnost_inteligence] * 3);
maxSh = 0;
maxSt = 0;

#define apiPlayerUpdateKeysFromConfig
/// apiPlayerUpdateKeysFromConfig()

ini_open("config.cfg");
testKey = ini_read_real("keybinding", "move_right", 68);
ini_close();

#define apiPlayerSetProperty
/// apiPlayerSetProperty(index, value)

var i, v;
i = 0;
v = 0;

if (argument_count > 0) {i = argument[0];}
if (argument_count > 1) {v = argument[1];}

oPlayer.vlastnost[i] = v;

#define apiPlayerAssignSpell
/// apiPlayerAssignSpell(index, name, sprite)

var i, n, s;
i = 0;
n = "";
s = sFreeSlot;

if (argument_count > 0) {i = argument[0];}
if (argument_count > 1) {n = argument[1];}
if (argument_count > 2) {s = argument[2];}

spell[i]        = n;
spell_sprite[i] = s;
#define apiPlayerSetGold
/// apiPlayerSetGold(amount, applyBonusGold, relative)

var a, abg, r;
a   = 1;
abg = false;
r   = true;

if (argument_count > 0) {a   = argument[0];}
if (argument_count > 1) {abg = argument[1];}
if (argument_count > 2) {r   = argument[2];}

if (!abg)
    {
     if (r) {oPlayer.gold += a;} else {oPlayer.gold = r;}
    }
else
    {
     if (r) {oPlayer.gold += (a + (a * oPlayer.vlastnost[vlastnost_bonusGold]));} else {oPlayer.gold = (a + (a * oPlayer.vlastnost[vlastnost_bonusGold]));}
    }
#define apiPlayerGetPropertyValue
/// apiPlayerGetPropertyValue(index, [returnAsString], [sumWithStatic])

var i, r, s;
i = vlastnost_zivot;
r = false;
s = false;

if (argument_count > 0) {i = argument[0];}
if (argument_count > 1) {r = argument[1];}
if (argument_count > 2) {s = argument[2];}


if (r) {if (s) {return string(oPlayer.vlastnost[i] + oPlayer.vlastnostStatic[i]);} else {return string(oPlayer.vlastnost[i])}}
if (s) {return (oPlayer.vlastnost[i] + oPlayer.vlastnostStatic[i]);}
return (oPlayer.vlastnost[i]);

#define apiPlayerSplashEmoticon
/// apiPlayerSplashEmoticon(index, animationSpeed)

var i, I, a;
I = 0;
a = 0.1;

if (argument_count > 0) {I = argument[0];}
if (argument_count > 1) {a = argument[1];}

i = instance_create(oPlayer.x, oPlayer.y - 16, oEmoticon);
i.spd         = a;
i.image_index = i;
#define apiPlayerGetHealth
/// apiPlayerGetHealth(value)

var v;
v = 0;

if (argument_count > 0) {v = argument[0];}

oPlayer.vlastnost[vlastnost_zivot] +=  v;

return(v);
#define apiPlayerIncProperty
/// apiPlayerIncProperty(index, value)

var i, v;
i = 0;
v = 0;

if (argument_count > 0) {i = argument[0];}
if (argument_count > 1) {v = argument[1];}

oPlayer.vlastnost[i] += v;
#define apiPlayerGetPropertyStaticValue
/// apiPlayerGetPropertyStaticValue(index, [returnAsString])

var i,r;
i = vlastnost_zivot;
r = false;

if (argument_count > 0) {i = argument[0];}
if (argument_count > 1) {r = argument[1];}

if (r) {return string(oPlayer.vlastnostStatic[i]);}
return (oPlayer.vlastnostStatic[i]);