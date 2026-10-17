if ((!variable_global_exists("em_batalha") || !global.em_batalha)
    && room != Batalhas
    && variable_global_exists("enfermeira_dialogo_ativo") && global.enfermeira_dialogo_ativo)
{
    var _cam_dialogo = view_camera[0];
    var _dx = camera_get_view_x(_cam_dialogo) + 20;
    var _dy = camera_get_view_y(_cam_dialogo) + camera_get_view_height(_cam_dialogo) - 62;
    var _dw = camera_get_view_width(_cam_dialogo) - 40;
    draw_set_color(c_black);
    draw_rectangle(_dx, _dy, _dx + _dw, _dy + 42, false);
    draw_set_color(c_white);
    draw_rectangle(_dx, _dy, _dx + _dw, _dy + 42, true);
    draw_set_font(Pokemon);
    draw_set_color(c_white);
    draw_text_ext_transformed(_dx + 10, _dy + 8, global.enfermeira_dialogo_texto,
        4, (_dw - 20) / 0.20, 0.20, 0.20, 0);
    draw_set_color(c_white);
}

if (room == cena_batalha)
{
    if (variable_instance_exists(id, "treinador_ia"))
        scr_hud_cena_batalha_desenhar_pokemon(global.equipe_jogador, treinador_ia);
    if (global.hud_batalha_dialogo_texto != ""
        || array_length(global.hud_batalha_dialogo_fila) > 0
        || (variable_global_exists("hud_batalha_xp_anim_aguardando")
            && global.hud_batalha_xp_anim_aguardando))
    {
        scr_hud_batalha_desenhar_dialogo();
        exit;
    }
    if (global.hud_batalha_menu_estado == "menu")
    {
        var _icones = [hud_fight, hud_pkmn, hud_bag, hud_run];
        var _icones_y = [477, 610, 742, 876];
        for (var _i_icone = 0; _i_icone < array_length(_icones); _i_icone++)
            draw_sprite(_icones[_i_icone], 0, 66, _icones_y[_i_icone]);

        var _seta_x = [206, 206, 206, 206];
        var _seta_y = [512, 645, 777, 911];
        var _opcao_selecionada = clamp(global.hud_batalha_menu_index, 0, 3);
        draw_sprite_ext(seta_2, 0, _seta_x[_opcao_selecionada], _seta_y[_opcao_selecionada],
            1, 1, 0, c_white, 1);
    }
    else if (global.hud_batalha_menu_estado == "bag")
    {
        scr_menu_bag_batalha_desenhar();
    }
    else if (global.hud_batalha_menu_estado == "fight")
    {
        var _pokemon_ativo = scr_get_monstro_ativo(global.equipe_jogador);
        var _pos_x_ataques = [1161, 1540, 1161, 1540];
        var _pos_y_ataques = [818, 818, 902, 902];
        var _qtd_ataques = min(array_length(_pokemon_ativo.movimentos), 4);
        var _ataque_selecionado = clamp(global.hud_batalha_golpe_index, 0, max(0, _qtd_ataques - 1));

        for (var _i_ataque = 0; _i_ataque < 4; _i_ataque++)
        {
            var _sprite_ataque = atk_test;
            if (_i_ataque < _qtd_ataques)
            {
                var _movimento = _pokemon_ativo.movimentos[_i_ataque];
                var _dados_movimento = global.movimentos[$ _movimento.movimento_id];
                var _sprite_tipo = scr_hud_batalha_sprite_tipo_movimento(_dados_movimento.tipo);
                if (_sprite_tipo != -1) _sprite_ataque = _sprite_tipo;
            }

            if (_i_ataque == _ataque_selecionado && _i_ataque < _qtd_ataques)
            {
                draw_set_color(c_white);
                draw_rectangle(
                    _pos_x_ataques[_i_ataque] - 3,
                    _pos_y_ataques[_i_ataque] - 3,
                    _pos_x_ataques[_i_ataque] + sprite_get_width(_sprite_ataque) + 3,
                    _pos_y_ataques[_i_ataque] + sprite_get_height(_sprite_ataque) + 3,
                    true
                );
            }
            draw_sprite(_sprite_ataque, 0, _pos_x_ataques[_i_ataque], _pos_y_ataques[_i_ataque]);

            if (_i_ataque < _qtd_ataques)
            {
                var _texto_nome_ataque = _dados_movimento.nome;
                var _texto_pp_ataque = string(_movimento.pp_atual)
                    + "/" + string(_dados_movimento.pp_max);
                var _escala_texto_ataque = 0.8;
                var _texto_y_ataque = _pos_y_ataques[_i_ataque] + 20;
                var _texto_x_nome = _pos_x_ataques[_i_ataque] + 22;
                var _texto_x_pp = _pos_x_ataques[_i_ataque] + 275;

                draw_set_font(Pokemon);
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
                draw_set_color(c_black);
                draw_text_transformed(
                    _texto_x_nome,
                    _texto_y_ataque,
                    _texto_nome_ataque,
                    _escala_texto_ataque,
                    _escala_texto_ataque,
                    0
                );

                draw_set_halign(fa_right);
                draw_set_color(c_black);
                draw_text_transformed(
                    _texto_x_pp,
                    _texto_y_ataque,
                    _texto_pp_ataque,
                    _escala_texto_ataque,
                    _escala_texto_ataque,
                    0
                );
            }
        }
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_black);
    }
    exit;
}

if (room != Batalhas)
{
    if (global.menu_treinador_aberto)
        scr_menu_treinador_desenhar();
    exit;
}

if (!variable_global_exists("em_batalha") || !global.em_batalha)
{
    exit;
}

if (!variable_global_exists("equipe_jogador") || !variable_global_exists("campo"))
{
    exit;
}

if (!variable_instance_exists(id, "treinador_ia") || !variable_instance_exists(id, "teste_turno"))
{
    exit;
}

scr_hud_batalha_desenhar(global.equipe_jogador, treinador_ia, teste_turno);
