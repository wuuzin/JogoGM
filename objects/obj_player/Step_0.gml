if (variable_global_exists("retorno_enfermeira_pendente") && global.retorno_enfermeira_pendente
    && variable_global_exists("ultima_enfermeira_room")
    && room == global.ultima_enfermeira_room)
{
    x = global.ultima_enfermeira_x;
    y = global.ultima_enfermeira_y + 32;
    global.retorno_enfermeira_pendente = false;
}

if (keyboard_check_pressed(vk_space))
{
    var _enfermeira = instance_nearest(x, y, obj_enfermeira);
    if (instance_exists(_enfermeira))
        scr_enfermeira_interagir(_enfermeira);
}

if (global.menu_treinador_aberto && (!variable_global_exists("em_batalha") || !global.em_batalha))
{
    if (global.menu_treinador_submenu == "bag")
    {
        var _bag_x = camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]) - 286;
        var _bag_y = camera_get_view_y(view_camera[0]) + 16;
        var _bag_divisoes = global.mochila.divisoes;
        var _bag_itens = [];
        for (var _bag_i = 0; _bag_i < array_length(global.mochila.lista); _bag_i++)
        {
            var _bag_id = global.mochila.lista[_bag_i];
            if (global.itens[$ _bag_id].divisao == _bag_divisoes[global.menu_bag_divisao]
                && global.mochila.itens[$ _bag_id] > 0)
                array_push(_bag_itens, _bag_id);
        }
        if (mouse_x >= _bag_x && mouse_x <= _bag_x + 145 && mouse_y >= _bag_y + 30 && mouse_y <= _bag_y + 120)
        {
            global.menu_bag_item_index = clamp(floor((mouse_y - (_bag_y + 30)) / 21), 0, max(0, array_length(_bag_itens) - 1));
            if (mouse_check_button_pressed(mb_left) && array_length(_bag_itens) > 0)
            {
                global.menu_bag_item_pendente = _bag_itens[global.menu_bag_item_index];
                global.menu_bag_opcao = 0;
                global.menu_treinador_submenu = "bag_opcoes";
                exit;
            }
        }
        if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A")))
        {
            global.menu_bag_divisao = (global.menu_bag_divisao + array_length(_bag_divisoes) - 1) mod array_length(_bag_divisoes);
            global.menu_bag_item_index = 0;
            global.menu_bag_scroll = 0;
        }
        if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D")))
        {
            global.menu_bag_divisao = (global.menu_bag_divisao + 1) mod array_length(_bag_divisoes);
            global.menu_bag_item_index = 0;
            global.menu_bag_scroll = 0;
        }
        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")))
        {
            global.menu_bag_item_index = max(0, global.menu_bag_item_index - 1);
            global.menu_bag_scroll = min(global.menu_bag_scroll, global.menu_bag_item_index);
        }
        if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
        {
            global.menu_bag_item_index = min(max(0, array_length(_bag_itens) - 1), global.menu_bag_item_index + 1);
            global.menu_bag_scroll = max(global.menu_bag_scroll, global.menu_bag_item_index - 3);
        }
        if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))
        {
            if (array_length(_bag_itens) > 0)
            {
                global.menu_bag_item_pendente = _bag_itens[global.menu_bag_item_index];
                global.menu_bag_opcao = 0;
                global.menu_treinador_submenu = "bag_opcoes";
            }
        }
        if (keyboard_check_pressed(ord("Q")) && array_length(_bag_itens) > 0)
        {
            var _item_descartar = global.itens[$ _bag_itens[global.menu_bag_item_index]];
            if (!variable_struct_exists(_item_descartar, "descartavel") || _item_descartar.descartavel)
                scr_mochila_remover(_bag_itens[global.menu_bag_item_index], 1);
        }
        if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("X")))
            global.menu_treinador_submenu = "";
        exit;
    }

    if (global.menu_treinador_submenu == "bag_opcoes")
    {
        var _item_opcoes = global.itens[$ global.menu_bag_item_pendente];
        var _pode_segur = variable_struct_exists(_item_opcoes, "seguravel") && _item_opcoes.seguravel;
        var _qtd_opcoes = _pode_segur ? 3 : 2;
        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")))
            global.menu_bag_opcao = max(0, global.menu_bag_opcao - 1);
        if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
            global.menu_bag_opcao = min(_qtd_opcoes - 1, global.menu_bag_opcao + 1);
        if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))
        {
            if (global.menu_bag_opcao == 0)
            {
                global.menu_bag_acao = "usar";
                global.menu_pokemon_index = 0;
                global.menu_treinador_submenu = "pokemon";
            }
            else if (_pode_segur && global.menu_bag_opcao == 1)
            {
                global.menu_bag_acao = "segurar";
                global.menu_pokemon_index = 0;
                global.menu_treinador_submenu = "pokemon";
            }
            else
            {
                var _item_descartar = global.itens[$ global.menu_bag_item_pendente];
                if (!variable_struct_exists(_item_descartar, "descartavel") || _item_descartar.descartavel)
                    scr_mochila_remover(global.menu_bag_item_pendente, 1);
                global.menu_treinador_submenu = "bag";
            }
        }
        if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("X")))
            global.menu_treinador_submenu = "bag";
        exit;
    }

    if (global.menu_treinador_submenu == "bag_pokemon")
    {
        var _equipe = global.equipe_jogador.monstros;
        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")))
            global.menu_bag_item_index = max(0, global.menu_bag_item_index - 1);
        if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
            global.menu_bag_item_index = min(array_length(_equipe) - 1, global.menu_bag_item_index + 1);
        if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))
        {
            if (array_length(_equipe) > 0)
            {
                if (_equipe[global.menu_bag_item_index].held_item != "")
                    scr_mochila_adicionar(_equipe[global.menu_bag_item_index].held_item, 1);
                _equipe[global.menu_bag_item_index].held_item = global.menu_bag_item_pendente;
                global.menu_bag_item_pendente = "";
                global.menu_treinador_submenu = "bag";
            }
        }
        if (keyboard_check_pressed(ord("Q")) && array_length(_equipe) > 0)
        {
            if (_equipe[global.menu_bag_item_index].held_item != "")
            {
                scr_mochila_adicionar(_equipe[global.menu_bag_item_index].held_item, 1);
                _equipe[global.menu_bag_item_index].held_item = "";
            }
        }
        if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("X")))
        {
            if (global.menu_bag_item_pendente != "")
                scr_mochila_adicionar(global.menu_bag_item_pendente, 1);
            global.menu_bag_item_pendente = "";
            global.menu_treinador_submenu = "bag";
        }
        exit;
    }

    if (global.menu_treinador_submenu == "pokemon")
    {
        var _pokemon_qtd = array_length(global.equipe_jogador.monstros);
        var _acao_item = global.menu_bag_acao;
        var _pokemon_camera = view_camera[0];
        var _pokemon_sx = camera_get_view_width(_pokemon_camera) / 1920;
        var _pokemon_sy = camera_get_view_height(_pokemon_camera) / 1280;
        var _pokemon_mx = (mouse_x - camera_get_view_x(_pokemon_camera)) / _pokemon_sx;
        var _pokemon_my = (mouse_y - camera_get_view_y(_pokemon_camera)) / _pokemon_sy;
        if (_pokemon_mx >= 146 && _pokemon_mx <= 1720 && _pokemon_my >= 182 && _pokemon_my <= 1080)
        {
            var _pokemon_col = floor((_pokemon_mx - 146) / 754);
            var _pokemon_row = floor((_pokemon_my - 182) / 194);
            var _pokemon_mouse_index = (_pokemon_row * 2) + _pokemon_col;
            if (_pokemon_mouse_index >= 0 && _pokemon_mouse_index < _pokemon_qtd)
            {
                global.menu_pokemon_index = _pokemon_mouse_index;
                if (mouse_check_button_pressed(mb_left))
                {
                    global.hud_batalha_pokemon_index = global.menu_pokemon_index;
                    if (_acao_item != "")
                    {
                        scr_menu_item_aplicar_no_pokemon(global.menu_pokemon_index);
                        global.menu_bag_acao = "";
                        global.menu_bag_item_pendente = "";
                        global.menu_treinador_submenu = "bag";
                        exit;
                    }
                    global.menu_pokemon_opcao = 0;
                    global.menu_treinador_submenu = "pokemon_opcoes";
                    exit;
                }
            }
        }
        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")))
            global.menu_pokemon_index = max(0, global.menu_pokemon_index - 1);
        if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
            global.menu_pokemon_index = min(max(0, _pokemon_qtd - 1), global.menu_pokemon_index + 1);
        if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))
        {
            if (_pokemon_qtd > 0)
            {
                global.hud_batalha_pokemon_index = global.menu_pokemon_index;
                if (_acao_item != "")
                {
                    scr_menu_item_aplicar_no_pokemon(global.menu_pokemon_index);
                    global.menu_bag_acao = "";
                    global.menu_bag_item_pendente = "";
                    global.menu_treinador_submenu = "bag";
                    exit;
                }
                global.menu_pokemon_opcao = 0;
                global.menu_treinador_submenu = "pokemon_opcoes";
            }
        }
        if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("X")))
        {
            if (_acao_item != "")
            {
                global.menu_bag_acao = "";
                global.menu_bag_item_pendente = "";
                global.menu_treinador_submenu = "bag";
            }
            else
            {
                global.menu_treinador_submenu = "";
            }
        }
        exit;
    }

    if (global.menu_treinador_submenu == "pokemon_opcoes")
    {
        var _opcoes_pokemon = 3;
        var _op_camera = view_camera[0];
        var _op_sx = camera_get_view_width(_op_camera) / 1920;
        var _op_sy = camera_get_view_height(_op_camera) / 1280;
        var _op_mx = (mouse_x - camera_get_view_x(_op_camera)) / _op_sx;
        var _op_my = (mouse_y - camera_get_view_y(_op_camera)) / _op_sy;
        if (_op_mx >= 1360 && _op_mx <= 1780 && _op_my >= 300 && _op_my <= 600)
        {
            var _op_mouse = clamp(floor((_op_my - 378) / 60), 0, 2);
            global.menu_pokemon_opcao = _op_mouse;
            if (mouse_check_button_pressed(mb_left))
            {
                if (_op_mouse == 0) global.menu_treinador_submenu = "pokemon_sumario";
                else if (_op_mouse == 1)
                {
                    var _mouse_selected = global.menu_pokemon_index;
                    var _mouse_active = global.equipe_jogador.indice_ativo;
                    if (_mouse_selected != _mouse_active)
                    {
                        var _mouse_temp = global.equipe_jogador.monstros[_mouse_active];
                        global.equipe_jogador.monstros[_mouse_active] = global.equipe_jogador.monstros[_mouse_selected];
                        global.equipe_jogador.monstros[_mouse_selected] = _mouse_temp;
                    }
                    global.menu_treinador_submenu = "pokemon";
                }
                else global.menu_treinador_submenu = "pokemon";
                exit;
            }
        }
        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")))
            global.menu_pokemon_opcao = max(0, global.menu_pokemon_opcao - 1);
        if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
            global.menu_pokemon_opcao = min(_opcoes_pokemon - 1, global.menu_pokemon_opcao + 1);
        if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))
        {
            if (global.menu_pokemon_opcao == 0)
            {
                global.menu_treinador_submenu = "pokemon_sumario";
            }
            else if (global.menu_pokemon_opcao == 1 && array_length(global.equipe_jogador.monstros) > 1)
            {
                var _selecionado = global.hud_batalha_pokemon_index;
                var _ativo = global.equipe_jogador.indice_ativo;
                var _temporario = global.equipe_jogador.monstros[_ativo];
                global.equipe_jogador.monstros[_ativo] = global.equipe_jogador.monstros[_selecionado];
                global.equipe_jogador.monstros[_selecionado] = _temporario;
                global.menu_pokemon_index = _ativo;
            }
            if (global.menu_pokemon_opcao == 2)
                global.menu_treinador_submenu = "pokemon";
            else if (global.menu_pokemon_opcao == 1)
                global.menu_treinador_submenu = "pokemon";
        }
        if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("X")))
            global.menu_treinador_submenu = "pokemon";
        exit;
    }

    if (global.menu_treinador_submenu == "pokemon_sumario")
    {
        if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("X")))
            global.menu_treinador_submenu = "pokemon_opcoes";
        exit;
    }

    var _menu_x = camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]) - 136;
    var _menu_y = camera_get_view_y(view_camera[0]) + 8;
    if (mouse_x >= _menu_x && mouse_x <= _menu_x + 160
        && mouse_y >= _menu_y + 9 && mouse_y <= _menu_y + 156)
    {
        global.menu_treinador_index = clamp(floor((mouse_y - (_menu_y + 9)) / 21), 0, 6);
        if (mouse_check_button_pressed(mb_left))
        {
            switch (global.menu_treinador_index)
            {
                case 0: global.menu_treinador_submenu = "pokedex"; break;
                case 1:
                    global.menu_pokemon_index = 0;
                    global.menu_treinador_submenu = "pokemon";
                    break;
                case 2: global.menu_treinador_submenu = "bag"; break;
                case 3: global.menu_treinador_submenu = "treinador"; break;
                case 4: scr_jogo_salvar(); break;
                case 5: global.menu_treinador_submenu = "opcoes"; break;
                case 6:
                    global.menu_treinador_aberto = false;
                    global.menu_treinador_submenu = "";
                    break;
            }
        }
    }
    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")))
        global.menu_treinador_index = max(0, global.menu_treinador_index - 1);
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
        global.menu_treinador_index = min(6, global.menu_treinador_index + 1);
    if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("X")))
    {
        if (global.menu_treinador_submenu != "") global.menu_treinador_submenu = "";
        else global.menu_treinador_aberto = false;
    }
    else if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))
    {
        switch (global.menu_treinador_index)
        {
            case 0: global.menu_treinador_submenu = "pokedex"; break;
            case 1:
                global.menu_pokemon_index = 0;
                global.menu_treinador_submenu = "pokemon";
                break;
            case 2: global.menu_treinador_submenu = "bag"; break;
            case 3: global.menu_treinador_submenu = "treinador"; break;
            case 4: scr_jogo_salvar(); break;
            case 5: global.menu_treinador_submenu = "opcoes"; break;
            case 6:
                global.menu_treinador_aberto = false;
                global.menu_treinador_submenu = "";
                break;
        }
    }
    exit;
}

if (variable_global_exists("em_batalha") && global.em_batalha)
{
    spdh = 0;
    spdv = 0;
    exit;
}

if (keyboard_check_pressed(vk_escape))
{
    global.menu_treinador_aberto = true;
    global.menu_treinador_index = 4;
    global.menu_treinador_submenu = "";
    exit;
}


// CAMINHAR
up = keyboard_check(ord("W"));
down = keyboard_check(ord("S"));
right = keyboard_check(ord("D"));
left = keyboard_check(ord("A"));
velv = (down - up);
velh = (right - left);
spdh = clamp(spdh, -vel, vel);
spdv = clamp(spdv, -vel, vel);

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

// ANIMAÇÕES
if (spdv < 0)
{
    sprite_index = sprite_up;
    face = "up";
}
else if (spdv > 0)
{
    sprite_index = sprite_down;
    face = "down";
}
else if (spdh > 0)
{
    sprite_index = sprite_right;
    face = "right";
}
else if (spdh < 0)
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
