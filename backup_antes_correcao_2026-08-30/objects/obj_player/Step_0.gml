if (global.em_batalha) exit; 


// CAMINHAR
up = keyboard_check(ord("W"));
down = keyboard_check(ord("S"));
right = keyboard_check(ord("D"));
left = keyboard_check(ord("A"));
velv = (down - up);
velh = (right - left);
spdh = clamp(spdh, -vel, vel);
spdv = clamp(spdv, -vel, vel);
x += spdh;
y += spdv;

if (velh != 0)
{
    spdh += velh * acel;
}
else
{
    spdh = approach(spdh, 0, acel);
}

if (velv != 0)
{
    spdv += velv * acel;
}
else
{
    spdv = approach(spdv, 0, acel);
}
if (spdh != 0 && spdv != 0)
{
    var _mag = sqrt(spdh * spdh + spdv * spdv);
    if (_mag > vel)
    {
        var _fator = vel / _mag;
        spdh *= _fator;
        spdv *= _fator;
    }
}
if (velh != 0)
{
    spdh += velh * acel;
}
else
{
    spdh = approach(spdh, 0, freio);
}
if (velv != 0)
{
    spdv += velv * acel;
}
else
{
    spdv = approach(spdv, 0, freio);
}


// ANIMAÇÕES
if (velv <= -1)
{
    sprite_index = sprite_up;
}
else if (velv >= 1)
{
    sprite_index = sprite_down;
}
else if (velh >= 1)
{
    sprite_index = sprite_right;
}
else if (velh <= -1)
{
    sprite_index = sprite_left;
}
else
{
    sprite_index = sprite_iddle_down;
}

if (velv <= -1)
{
    sprite_index = sprite_up;
    face = "up";
}
else if (velv >= 1)
{
    sprite_index = sprite_down;
    face = "down";
}
else if (velh >= 1)
{
    sprite_index = sprite_right;
    face = "right";
}
else if (velh <= -1)
{
    sprite_index = sprite_left;
    face = "left";
}
else
{
    
    switch (face)
    {
        case "up":
            sprite_index = sprite_iddle_up;
            break;
        case "down":
            sprite_index = sprite_iddle_down;
            break;
        case "left":
            sprite_index = sprite_iddle_left;
            break;
        case "right":
            sprite_index = sprite_iddle_right;
            break;
    }
}