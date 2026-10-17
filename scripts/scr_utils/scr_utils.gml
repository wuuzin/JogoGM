function scr_mochila_obter_divisao(divisao)
{
    var _resultado = [];
    for (var _i = 0; _i < array_length(global.mochila.lista); _i++)
    {
        var _id = global.mochila.lista[_i];
        if (global.itens[$ _id].divisao == divisao && global.mochila.itens[$ _id] > 0)
            array_push(_resultado, _id);
    }

    return _resultado;
}

function scr_menu_bag_desenhar(_x, _y, _cor_texto = c_white)
{
    var _w = 145;
    var _h = 150;
    var _divisao = global.mochila.divisoes[global.menu_bag_divisao];
    var _itens = scr_mochila_obter_divisao(_divisao);
    var _indice_selecionado = global.menu_bag_item_index;
    if (global.em_batalha)
    {
        _indice_selecionado = global.hud_batalha_bag_index;
        global.menu_bag_item_index = _indice_selecionado;
        global.menu_bag_scroll = max(0, _indice_selecionado - 3);
    }
    draw_set_color(c_black);
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);
    draw_set_color(c_white);
    draw_rectangle(_x + 2, _y + 2, _x + _w - 2, _y + _h - 2, true);
    draw_set_color(_cor_texto);
    draw_text_transformed(_x + 8, _y + 8, string_upper(_divisao), 0.28, 0.28, 0);
    draw_text_transformed(_x + 8, _y + 132, "<  >", 0.25, 0.25, 0);
    var _max_scroll = max(0, array_length(_itens) - 4);
    global.menu_bag_scroll = clamp(global.menu_bag_scroll, 0, _max_scroll);
    var _inicio = global.menu_bag_scroll;
    var _fim = min(array_length(_itens), _inicio + 4);
    for (var _i = _inicio; _i < _fim; _i++)
    {
        var _linha_y = _y + 32 + ((_i - _inicio) * 21);
        draw_set_color(_i == _indice_selecionado ? make_color_rgb(70, 70, 70) : c_black);
        draw_rectangle(_x + 6, _linha_y - 2, _x + _w - 6, _linha_y + 16, false);
        draw_set_color(_cor_texto);
        var _item = global.itens[$ _itens[_i]];
        draw_text_transformed(_x + 10, _linha_y, _item.nome + " x" + string(global.mochila.itens[$ _itens[_i]]), 0.25, 0.25, 0);
    }
    if (array_length(_itens) > 0)
    {
        var _selecionado = global.itens[$ _itens[clamp(global.menu_bag_item_index, 0, array_length(_itens) - 1)]];
        draw_set_color(_cor_texto);
            draw_text_ext_transformed(_x + 8, _y + 118, _selecionado.descricao, 4, (_w - 16) / 0.20, 0.20, 0.20, 0);
    }
}

function scr_menu_bag_batalha_desenhar()
{
    var _camera = view_camera[0];
    var _escala = (camera_get_view_width(_camera) / 384) * 1.35;
    var _matriz_anterior = matrix_get(matrix_world);
    matrix_set(matrix_world, matrix_build(
        camera_get_view_x(_camera),
        camera_get_view_y(_camera),
        0,
        0,
        0,
        0,
        _escala,
        _escala,
        1
    ));
    scr_menu_bag_desenhar(190, 30, c_black);
    matrix_set(matrix_world, _matriz_anterior);
}

function scr_menu_bag_pokemon_desenhar(_x, _y)
{
    var _w = 145;
    var _h = 150;
    draw_set_color(c_black);
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);
    draw_set_color(c_white);
    draw_rectangle(_x + 2, _y + 2, _x + _w - 2, _y + _h - 2, true);
    draw_text_transformed(_x + 8, _y + 8, "DAR ITEM", 0.28, 0.28, 0);
    for (var _i = 0; _i < min(array_length(global.equipe_jogador.monstros), 4); _i++)
    {
        var _linha_y = _y + 32 + (_i * 21);
        draw_set_color(_i == global.menu_bag_item_index ? make_color_rgb(70, 70, 70) : c_black);
        draw_rectangle(_x + 6, _linha_y - 2, _x + _w - 6, _linha_y + 16, false);
        draw_set_color(c_white);
        var _monstro = global.equipe_jogador.monstros[_i];
        var _held = (_monstro.held_item == "") ? "" : " [" + global.itens[$ _monstro.held_item].nome + "]";
        draw_text_transformed(_x + 10, _linha_y, _monstro.nome + _held, 0.25, 0.25, 0);
    }
}

function scr_hud_batalha_sprite_tipo_movimento(_tipo)
{
    switch (_tipo)
    {
        case "normal": return atk_normal;
        case "fogo": return atk_fire;
        case "agua": return atk_water;
        case "planta": return atk_grass;
        case "eletrico": return atk_eletric;
        case "terra": return atk_ground;
        case "voador": return atk_flying;
        case "veneno": return atk_poison;
        case "fantasma": return atk_ghost;
        case "noturno": return atk_dark;
        case "fada": return atk_fairy;
        case "metal": return atk_steel;
        case "lutador": return atk_fighting;
        case "psiquico": return atk_psychic;
        case "pedra": return atk_rock;
        case "dragao": return atk_dragon;
        case "gelo": return atk_ice;
        case "inseto": return atk_bug;
    }

    return -1;
}

function scr_jogador_escolher_acao(treinador_jogador)
{
    if (!variable_global_exists("hud_batalha_menu_estado") || global.hud_batalha_menu_estado != "fight")
    {
        return { tipo: "nenhum" };
    }

    var _ativo = scr_get_monstro_ativo(treinador_jogador);
    if (!_ativo.esta_desmaiado)
    {
        var _qtd_movimentos = min(array_length(_ativo.movimentos), 4);
        if (_qtd_movimentos <= 0) return { tipo: "nenhum" };

        if (room == cena_batalha)
        {
            var _pos_x = [1161, 1540, 1161, 1540];
            var _pos_y = [818, 818, 902, 902];
            var _icone_w = sprite_get_width(atk_test);
            var _icone_h = sprite_get_height(atk_test);
            var _indice_mouse = -1;
            var _mouse_movido = false;

            global.hud_batalha_golpe_index = clamp(
                global.hud_batalha_golpe_index, 0, _qtd_movimentos - 1);

            if (!variable_instance_exists(id, "hud_ataque_mouse_x"))
            {
                hud_ataque_mouse_x = mouse_x;
                hud_ataque_mouse_y = mouse_y;
            }
            else
            {
                _mouse_movido = mouse_x != hud_ataque_mouse_x || mouse_y != hud_ataque_mouse_y;
                hud_ataque_mouse_x = mouse_x;
                hud_ataque_mouse_y = mouse_y;
            }

            for (var _i_slot = 0; _i_slot < _qtd_movimentos; _i_slot++)
            {
                if (mouse_x >= _pos_x[_i_slot]
                    && mouse_x <= _pos_x[_i_slot] + _icone_w
                    && mouse_y >= _pos_y[_i_slot]
                    && mouse_y <= _pos_y[_i_slot] + _icone_h)
                {
                    _indice_mouse = _i_slot;
                    if (_mouse_movido) global.hud_batalha_golpe_index = _i_slot;
                    break;
                }
            }

            if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A")))
            {
                if (global.hud_batalha_golpe_index mod 2 == 1)
                    global.hud_batalha_golpe_index -= 1;
            }
            else if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D")))
            {
                if (global.hud_batalha_golpe_index mod 2 == 0
                    && global.hud_batalha_golpe_index + 1 < _qtd_movimentos)
                    global.hud_batalha_golpe_index += 1;
            }
            else if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")))
            {
                if (global.hud_batalha_golpe_index >= 2)
                    global.hud_batalha_golpe_index -= 2;
            }
            else if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
            {
                if (global.hud_batalha_golpe_index + 2 < _qtd_movimentos)
                    global.hud_batalha_golpe_index += 2;
                else if (global.hud_batalha_golpe_index == 1 && _qtd_movimentos == 3)
                    global.hud_batalha_golpe_index = 2;
            }

            if (mouse_check_button_pressed(mb_left) && _indice_mouse != -1)
            {
                global.hud_batalha_golpe_index = _indice_mouse;
                return { tipo: "atacar", indice: _indice_mouse };
            }

            if (keyboard_check_pressed(vk_enter)
                || keyboard_check_pressed(vk_space)
                || keyboard_check_pressed(ord("Z"))
                || keyboard_check_pressed(ord("z")))
            {
                return { tipo: "atacar", indice: global.hud_batalha_golpe_index };
            }

            return { tipo: "nenhum" };
        }

        var _fight_x = 620;
        var _fight_y = 1106;
        var _fight_w = 928;
        var _fight_h = 150;
        var _cell_w = _fight_w * 0.5;

        if (mouse_x >= _fight_x && mouse_x <= _fight_x + _fight_w
            && mouse_y >= _fight_y && mouse_y <= _fight_y + _fight_h)
        {
            var _coluna_mouse = clamp(floor((mouse_x - _fight_x) / _cell_w), 0, 1);
            var _linha_mouse = clamp(floor((mouse_y - (_fight_y + 8)) / 58), 0, 1);
            var _indice_mouse = (_linha_mouse * 2) + _coluna_mouse;

            if (_indice_mouse < _qtd_movimentos)
            {
                global.hud_batalha_golpe_index = _indice_mouse;
                if (mouse_check_button_pressed(mb_left))
                {
                    return { tipo: "atacar", indice: _indice_mouse };
                }
            }

        }

        if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A")))
        {
            global.hud_batalha_golpe_index = max(0, global.hud_batalha_golpe_index - 1);
        }
        else if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D")))
        {
            global.hud_batalha_golpe_index = min(_qtd_movimentos - 1, global.hud_batalha_golpe_index + 1);
        }
        else if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")))
        {
            global.hud_batalha_golpe_index = max(0, global.hud_batalha_golpe_index - 2);
        }
        else if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
        {
            global.hud_batalha_golpe_index = min(_qtd_movimentos - 1, global.hud_batalha_golpe_index + 2);
        }

        if (keyboard_check_pressed(vk_enter))
        {
            return { tipo: "atacar", indice: global.hud_batalha_golpe_index };
        }
    }

    return { tipo: "nenhum" };
}

function scr_escolha_aleatoria_ponderada(array_indices, array_pesos)
{
    var _soma = 0;
    for (var _i = 0; _i < array_length(array_pesos); _i++)
    {
        _soma += array_pesos[_i];
    }

    var _valor_sorteado = random(_soma);
    var _acumulado = 0;

    for (var _i = 0; _i < array_length(array_pesos); _i++)
    {
        _acumulado += array_pesos[_i];
        if (_valor_sorteado <= _acumulado)
        {
            return array_indices[_i];
        }
    }

    return array_indices[array_length(array_indices) - 1];
}

function scr_get_multiplicador_estagio(estagio)
{
    estagio = clamp(estagio, -6, 6);
    return (estagio >= 0) ? ((2 + estagio) / 2) : (2 / (2 - estagio));
}

function scr_get_stat_efetivo(monstro, stat_nome)
{
    var _base = monstro[$ stat_nome];
    var _estagio = monstro.estagios[$ stat_nome];
    var _mult = scr_get_multiplicador_estagio(_estagio);
    return floor(_base * _mult);
}

function scr_iniciar_batalha(equipe_ia_ids, nivel_ia, id_treinador)
{
    if (!scr_equipe_tem_vivos(global.equipe_jogador))
    {
        show_debug_message(">> Você não pode iniciar uma batalha: todos os seus Pokémon estão desmaiados.");
        return false;
    }

    treinador_jogador = global.equipe_jogador;
    var _primeiro_vivo = -1;
    for (var _i_eq = 0; _i_eq < array_length(treinador_jogador.monstros); _i_eq++)
    {
        scr_resetar_status_temporarios(treinador_jogador.monstros[_i_eq]);
        if (_primeiro_vivo == -1 && !treinador_jogador.monstros[_i_eq].esta_desmaiado)
            _primeiro_vivo = _i_eq;
    }
    if (_primeiro_vivo != -1)
        treinador_jogador.indice_ativo = _primeiro_vivo;

    treinador_ia = scr_criar_equipe(equipe_ia_ids, nivel_ia);
    treinador_ia.eh_selvagem = (id_treinador == noone);
    treinador_atual_id = id_treinador; // guarda quem chamou, pra avisar quando a batalha acabar

    // Cada batalha começa com a HUD e os diálogos em estado limpo.
    global.hud_batalha_menu_estado = "menu";
    global.hud_batalha_menu_index = 0;
    global.hud_batalha_golpe_index = 0;
    global.hud_batalha_pokemon_index = treinador_jogador.indice_ativo;
    global.hud_batalha_pokemon_opcao = 0;
    global.hud_batalha_bag_index = 0;
    global.hud_batalha_item_pendente = "";
    global.hud_batalha_pokemon_aviso = "";
    global.menu_treinador_aberto = false;
    global.menu_treinador_submenu = "";
    global.hud_batalha_fim_estado = "nenhum";
    global.hud_batalha_substituicao_obrigatoria = false;
    global.hud_batalha_dialogo_fila = [];
    global.hud_batalha_dialogo_texto = "";
    global.hud_batalha_dialogo_is_enemy = false;
    global.hud_batalha_dialogo_xp_ao_avancar = false;
    global.hud_batalha_xp_anim_bloqueada = false;
    global.hud_batalha_xp_anim_aguardando = false;
    global.hud_batalha_xp_anim_reiniciar = false;
    global.hud_batalha_xp_anim_final = 0;
    global.hud_batalha_pokeballs_jogador =
        scr_batalha_dialogo_pokeballs_snapshot(treinador_jogador);
    global.hud_batalha_pokeballs_inimigo =
        scr_batalha_dialogo_pokeballs_snapshot(treinador_ia);
    global.enfermeira_dialogo_ativo = false;
    global.enfermeira_dialogo_texto = "";
    global.hud_batalha_hp_anim = {
        jogador: { atual: treinador_jogador.monstros[treinador_jogador.indice_ativo].hp_atual, alvo: treinador_jogador.monstros[treinador_jogador.indice_ativo].hp_atual },
        inimigo: { atual: treinador_ia.monstros[treinador_ia.indice_ativo].hp_atual, alvo: treinador_ia.monstros[treinador_ia.indice_ativo].hp_atual }
    };
    var _xp_inicial = scr_progresso_xp_nivel(treinador_jogador.monstros[treinador_jogador.indice_ativo]);
    global.hud_batalha_xp_anim = { jogador: { atual: _xp_inicial, alvo: _xp_inicial } };

    teste_turno = 1;
    teste_batalha_acabou = false;
    pendente_substituicao = false;
    movimento_pendente_id = "";
    monstro_pendente = undefined;

    global.em_batalha = true;
    global.sala_antes_da_batalha = room;
    if (instance_exists(obj_player))
    {
        global.player_x_antes_da_batalha = obj_player.x;
        global.player_y_antes_da_batalha = obj_player.y;
    }

    show_debug_message("");
    show_debug_message("=============================================");
    show_debug_message("           UM TREINADOR TE DESAFIOU!          ");
    show_debug_message("=============================================");
    scr_exibir_turno_equipe(teste_turno, treinador_jogador, treinador_ia);

    room_goto(cena_batalha);

    return true;
}

function scr_jogo_salvar()
{
    var _dados = {
        jogador_x: obj_player.x,
        jogador_y: obj_player.y,
        equipe: global.equipe_jogador,
        mochila: global.mochila
    };
    var _arquivo = file_text_open_write("savegame.json");
    if (_arquivo < 0)
    {
        show_debug_message("Nao foi possivel criar o arquivo de salvamento.");
        return false;
    }
    file_text_write_string(_arquivo, json_stringify(_dados));
    file_text_close(_arquivo);
    global.menu_salvo_timer = room_speed * 2;
    show_debug_message("Jogo salvo.");
    return true;
}

function scr_menu_treinador_desenhar()
{
    var _w = 130;
    var _h = 183;
    var _camera = view_camera[0];
    var _x = camera_get_view_x(_camera) + camera_get_view_width(_camera) - _w - 6;
    var _y = camera_get_view_y(_camera) + 6;
    var _opcoes = ["POKEDEX", "POKEMON", "BAG", "TREINADOR", "SALVAR", "OPCAO", "SAIR"];
    var _escala_fonte = 0.32;
    var _cinza_selecao = make_color_rgb(70, 70, 70);

    draw_set_font(Pokemon);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_black);
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);
    draw_set_color(c_white);
    draw_rectangle(_x + 2, _y + 2, _x + _w - 2, _y + _h - 2, true);

    for (var _i = 0; _i < array_length(_opcoes); _i++)
    {
        var _linha_y = _y + 11 + (_i * 21);
        if (_i == global.menu_treinador_index)
        {
            draw_set_color(_cinza_selecao);
            draw_rectangle(_x + 8, _linha_y - 2, _x + _w - 8, _linha_y + 17, false);
        }

        draw_set_color(c_white);
        draw_text_transformed(_x + 16, _linha_y, (_i == global.menu_treinador_index ? "> " : "  ") + _opcoes[_i], _escala_fonte, _escala_fonte, 0);
    }

    if (global.menu_treinador_submenu == "pokemon")
    {
        scr_menu_pokemon_batalha_desenhar("pokemon");
    }
    else if (global.menu_treinador_submenu == "pokemon_opcoes")
    {
        scr_menu_pokemon_batalha_desenhar("pokemon_opcoes");
    }
    else if (global.menu_treinador_submenu == "pokemon_sumario")
    {
        scr_menu_pokemon_batalha_desenhar("pokemon_sumario");
    }
    else if (global.menu_treinador_submenu == "bag")
    {
        scr_menu_bag_desenhar(_x - 150, _y + 8);
    }

    else if (global.menu_treinador_submenu == "bag_pokemon")
    {
        scr_menu_bag_pokemon_desenhar(_x - 150, _y + 8);
    }
    else if (global.menu_treinador_submenu == "bag_opcoes")
    {
        scr_menu_bag_opcoes_desenhar(_x - 150, _y + 8);
    }

    else if (global.menu_treinador_submenu != "")
    {
        draw_set_color(c_black);
        draw_rectangle(_x - 170, _y + 18, _x - 10, _y + 150, false);
        draw_set_color(c_white);
        draw_rectangle(_x - 167, _y + 21, _x - 13, _y + 147, true);
        draw_set_color(c_white);
        switch (global.menu_treinador_submenu)
        {
            case "pokedex": draw_text_transformed(_x - 158, _y + 34, "Pokedex em breve.", _escala_fonte, _escala_fonte, 0); break;
            case "bag": draw_text_transformed(_x - 158, _y + 34, "Itens: " + string(array_length(global.mochila.lista)), _escala_fonte, _escala_fonte, 0); break;
            case "treinador": draw_text_transformed(_x - 158, _y + 34, "Treinador em breve.", _escala_fonte, _escala_fonte, 0); break;
            case "opcoes": draw_text_transformed(_x - 158, _y + 34, "Opcoes em breve.", _escala_fonte, _escala_fonte, 0); break;
        }

        draw_text_transformed(_x - 158, _y + 112, "ESC: voltar", _escala_fonte, _escala_fonte, 0);
    }

    if (variable_global_exists("menu_salvo_timer") && global.menu_salvo_timer > 0)
    {
        draw_set_color(c_black);
        draw_rectangle(_x + 8, _y + _h + 5, _x + _w - 8, _y + _h + 25, false);
        draw_set_color(c_white);
        draw_rectangle(_x + 8, _y + _h + 5, _x + _w - 8, _y + _h + 25, true);
        draw_text_transformed(_x + 20, _y + _h + 9, "Jogo salvo!", 0.22, 0.22, 0);
    }
}

function scr_menu_pokemon_batalha_desenhar(modo)
{
    var _camera = view_camera[0];
    var _escala_x = camera_get_view_width(_camera) / 1920;
    var _escala_y = camera_get_view_height(_camera) / 1280;
    global.hud_batalha_pokemon_index = global.menu_pokemon_index;
    global.hud_batalha_pokemon_opcao = global.menu_pokemon_opcao;
    var _matriz_anterior = matrix_get(matrix_world);
    matrix_set(matrix_world, matrix_build(
        camera_get_view_x(_camera),
        camera_get_view_y(_camera),
        0,
        0,
        0,
        0,
        _escala_x,
        _escala_y,
        1
    ));
    draw_set_alpha(1);
    draw_set_color(c_white);
    if (modo == "pokemon")
    {
        scr_hud_batalha_desenhar_menu_pokemon(global.equipe_jogador);
    }
    else if (modo == "pokemon_opcoes")
    {
        scr_hud_batalha_desenhar_menu_pokemon(global.equipe_jogador);
        scr_hud_batalha_desenhar_opcoes_pokemon(global.equipe_jogador);
    }
    else
    {
        scr_hud_batalha_desenhar_sumario_pokemon(global.equipe_jogador);
    }
    matrix_set(matrix_world, _matriz_anterior);
}

function scr_menu_item_aplicar_no_pokemon(_indice)
{
    var _item_id = global.menu_bag_item_pendente;
    var _pokemon = global.equipe_jogador.monstros[_indice];
    if (global.menu_bag_acao == "usar")
    {
        scr_mochila_usar_item_em_batalha(_item_id, _pokemon);
    }
    else if (global.menu_bag_acao == "segurar")
    {
        if (_pokemon.held_item != "")
            scr_mochila_adicionar(_pokemon.held_item, 1);
        _pokemon.held_item = _item_id;
        scr_mochila_remover(_item_id, 1);
    }
}

function scr_menu_bag_opcoes_desenhar(_x, _y)
{
    var _item = global.itens[$ global.menu_bag_item_pendente];
    var _pode_segur = variable_struct_exists(_item, "seguravel") && _item.seguravel;
    var _labels = _pode_segur ? ["USAR", "SEGURAR", "JOGAR FORA"] : ["USAR", "JOGAR FORA"];
    var _w = 145;
    var _h = 38 + (array_length(_labels) * 24);
    draw_set_color(c_black);
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);
    draw_set_color(c_white);
    draw_rectangle(_x + 2, _y + 2, _x + _w - 2, _y + _h - 2, true);
    draw_text_transformed(_x + 8, _y + 8, string_upper(_item.nome), 0.24, 0.24, 0);
    for (var _i = 0; _i < array_length(_labels); _i++)
    {
        var _linha_y = _y + 28 + (_i * 24);
        draw_set_color(_i == global.menu_bag_opcao ? make_color_rgb(70, 70, 70) : c_black);
        draw_rectangle(_x + 6, _linha_y - 2, _x + _w - 6, _linha_y + 18, false);
        draw_set_color(c_white);
        draw_text_transformed(_x + 12, _linha_y, _labels[_i], 0.22, 0.22, 0);
    }
}

