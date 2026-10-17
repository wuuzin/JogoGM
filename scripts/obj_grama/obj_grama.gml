function obj_grama_iniciar()
{
    cell_size = 32;
    last_cell_x = floor(x / cell_size);
    last_cell_y = floor(y / cell_size);
    wild_encounter_locked = false;
}

function obj_grama_verificar_passo()
{
    if (!global.em_batalha && wild_encounter_locked)
    {
        wild_encounter_locked = false;
    }

    var _cell_x = floor(x / cell_size);
    var _cell_y = floor(y / cell_size);

    if (_cell_x == last_cell_x && _cell_y == last_cell_y) return false;

    last_cell_x = _cell_x;
    last_cell_y = _cell_y;

    if (wild_encounter_locked) return false;
    if (!scr_grama_jogador_na_area(x, y + 12)) return false;

    wild_encounter_locked = true;
    if (scr_grama_tentar_encontro()) return true;

    wild_encounter_locked = false;
    return false;
}

function obj_grama_rearmar()
{
    wild_encounter_locked = false;
    last_cell_x = floor(x / cell_size);
    last_cell_y = floor(y / cell_size);
}