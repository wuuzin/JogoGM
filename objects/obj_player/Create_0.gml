oup = noone;
down = noone;
left = noone;
right = noone;

velh = 0;
velv = 0;
vel = 1;
acel = 0.02;
spdh = 0;
spdv = 0;
freio = 2;
face = "down";

scr_grama_passo_iniciar();

if (variable_global_exists("retorno_enfermeira_pendente") && global.retorno_enfermeira_pendente)
{
    if (variable_global_exists("ultima_enfermeira_room") && room == global.ultima_enfermeira_room)
    {
        x = global.ultima_enfermeira_x;
        y = global.ultima_enfermeira_y + 32;
        global.retorno_enfermeira_pendente = false;
    }
}
