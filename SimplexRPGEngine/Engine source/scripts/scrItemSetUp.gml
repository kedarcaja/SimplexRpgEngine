/// scrItemSetUp(animationSpeed, showNumber, id, canBeQuickUsed)

var in, canBeQuickUsed;
animate        = 0;
show_number    = 0;
points         = 0;
in             = false;
canBeQuickUsed = false;
points         = 0;
tempSpr        = sprite_index;
secure_pickup  = 0;

if (argument_count > 0) {animate          = argument[0];}
if (argument_count > 1) {show_number      = argument[1];}
if (argument_count > 2) {in               = argument[2];}
if (argument_count > 3) {canBeQuickUsed   = argument[3];}

image_speed                           = animate;
sprite_index                          = sTestItem;
scrItemBasic(in);

vlastnost[vlastnost_canBeFastEquiped] = canBeQuickUsed;
vlastnost[vlastnost_upgradeMaterial1] = materialEnum.materialPearl;
vlastnost[vlastnost_upgradeMaterial2] = materialEnum.materialPearl;
vlastnost[vlastnost_upgradeMaterial3] = materialEnum.materialPearl;
vlastnost[vlastnost_identified]       = true;
vlastnost[vlastnost_cursed]           = false;
vlastnost[vlastnost_pickSpr]          = tempSpr;



