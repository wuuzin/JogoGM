function scr_grama_obter_encontro()
{
    var _encontros = [
        { especie_id: "pidgey", chance: 50 },
        { especie_id: "caterpie", chance: 50 }
    ];

    var _sorteio = random(100);
    var _acumulado = 0;

    for (var _i = 0; _i < array_length(_encontros); _i++)
    {
        _acumulado += _encontros[_i].chance;
        if (_sorteio < _acumulado) return _encontros[_i].especie_id;
    }

    return _encontros[array_length(_encontros) - 1].especie_id;
}

function scr_grama_jogador_na_area(pos_x, pos_y)
{
    var _camadas = ["Pokemon"];

    for (var _i = 0; _i < array_length(_camadas); _i++)
    {
        var _layer_id = layer_get_id(_camadas[_i]);
        if (_layer_id == -1) continue;

        var _tilemap_id = layer_tilemap_get_id(_layer_id);
        if (_tilemap_id == -1) continue;

        var _tile = tilemap_get_at_pixel(_tilemap_id, pos_x, pos_y);
        var _tile_index = tile_get_index(_tile);
        if (_tile_index == 92 || _tile_index == 123) return true;
    }

    return false;
}

function scr_grama_tentar_encontro()
{
    if (global.em_batalha) return false;
    if (random(100) >= 10) return false;

    var _especie_id = scr_grama_obter_encontro();
    var _nivel = irandom_range(3, 6);

    global.wild_pokemon = {
        especie_id: _especie_id,
        nivel: _nivel
    };

    if (!instance_exists(obj_game))
    {
        show_debug_message(">> Encontro selvagem cancelado: obj_game não encontrado.");
        global.wild_pokemon = undefined;
        return false;
    }

    with (obj_game)
    {
        scr_iniciar_batalha([_especie_id], _nivel, noone);
    }

    return true;
}

function scr_grama_rearmar_encontros()
{
    if (instance_exists(obj_player))
    {
        with (obj_player)
        {
            obj_grama_rearmar();
        }
    }
}