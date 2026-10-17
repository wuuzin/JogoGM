if (variable_global_exists("menu_salvo_timer") && global.menu_salvo_timer > 0)
    global.menu_salvo_timer -= 1;

if (variable_global_exists("enfermeira_dialogo_ativo") && global.enfermeira_dialogo_ativo)
{
    if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)
        || mouse_check_button_pressed(mb_left))
    {
        global.enfermeira_dialogo_ativo = false;
        global.enfermeira_dialogo_texto = "";
    }
    exit;
}

if (variable_global_exists("retorno_enfermeira_pendente") && global.retorno_enfermeira_pendente
    && variable_global_exists("ultima_enfermeira_room")
    && room == global.ultima_enfermeira_room
    && instance_exists(obj_player))
{
    obj_player.x = global.ultima_enfermeira_x;
    obj_player.y = global.ultima_enfermeira_y + 32;
    global.retorno_enfermeira_pendente = false;
}

if (!global.em_batalha) exit;

var _p1_anim = scr_get_monstro_ativo(treinador_jogador);
var _p2_anim = scr_get_monstro_ativo(treinador_ia);
var _fator_animacao_hp = 1 - power(0.9, max(delta_time, 0) / (1000000 / 60));
if (!is_struct(global.hud_batalha_hp_anim))
{
    global.hud_batalha_hp_anim = {
        jogador: { atual: _p1_anim.hp_atual, alvo: _p1_anim.hp_atual },
        inimigo: { atual: _p2_anim.hp_atual, alvo: _p2_anim.hp_atual }
    };
}
else
{
    if (global.hud_batalha_hp_anim.jogador.alvo == 0 && global.hud_batalha_hp_anim.jogador.atual == 0)
    {
        global.hud_batalha_hp_anim.jogador.atual = _p1_anim.hp_atual;
        global.hud_batalha_hp_anim.jogador.alvo = _p1_anim.hp_atual;
    }
    if (global.hud_batalha_hp_anim.inimigo.alvo == 0 && global.hud_batalha_hp_anim.inimigo.atual == 0)
    {
        global.hud_batalha_hp_anim.inimigo.atual = _p2_anim.hp_atual;
        global.hud_batalha_hp_anim.inimigo.alvo = _p2_anim.hp_atual;
    }

    global.hud_batalha_hp_anim.jogador.atual = lerp(
        global.hud_batalha_hp_anim.jogador.atual,
        global.hud_batalha_hp_anim.jogador.alvo,
        _fator_animacao_hp
    );
    global.hud_batalha_hp_anim.inimigo.atual = lerp(
        global.hud_batalha_hp_anim.inimigo.atual,
        global.hud_batalha_hp_anim.inimigo.alvo,
        _fator_animacao_hp
    );

    if (abs(global.hud_batalha_hp_anim.jogador.alvo - global.hud_batalha_hp_anim.jogador.atual) < 0.2)
        global.hud_batalha_hp_anim.jogador.atual = global.hud_batalha_hp_anim.jogador.alvo;
    if (abs(global.hud_batalha_hp_anim.inimigo.alvo - global.hud_batalha_hp_anim.inimigo.atual) < 0.2)
        global.hud_batalha_hp_anim.inimigo.atual = global.hud_batalha_hp_anim.inimigo.alvo;
}

var _xp_jogador_alvo = scr_progresso_xp_nivel(_p1_anim);
if (!is_struct(global.hud_batalha_xp_anim)
    || !variable_struct_exists(global.hud_batalha_xp_anim, "jogador")
    || !is_struct(global.hud_batalha_xp_anim.jogador))
{
    global.hud_batalha_xp_anim = {
        jogador: { atual: _xp_jogador_alvo, alvo: _xp_jogador_alvo }
    };
}
else if (!variable_global_exists("hud_batalha_xp_anim_bloqueada")
    || !global.hud_batalha_xp_anim_bloqueada)
{
    global.hud_batalha_xp_anim.jogador.alvo = _xp_jogador_alvo;
    global.hud_batalha_xp_anim.jogador.atual = lerp(
        global.hud_batalha_xp_anim.jogador.atual,
        global.hud_batalha_xp_anim.jogador.alvo,
        _fator_animacao_hp
    );

    if (abs(global.hud_batalha_xp_anim.jogador.alvo - global.hud_batalha_xp_anim.jogador.atual) < 0.001)
        global.hud_batalha_xp_anim.jogador.atual = global.hud_batalha_xp_anim.jogador.alvo;
}

if (variable_global_exists("hud_batalha_xp_anim_aguardando")
    && global.hud_batalha_xp_anim_aguardando
    && abs(global.hud_batalha_xp_anim.jogador.alvo - global.hud_batalha_xp_anim.jogador.atual) < 0.001)
{
    if (global.hud_batalha_xp_anim_reiniciar)
    {
        global.hud_batalha_xp_anim.jogador.atual = 0;
        global.hud_batalha_xp_anim.jogador.alvo = global.hud_batalha_xp_anim_final;
        global.hud_batalha_xp_anim_reiniciar = false;
    }
    else
    {
        global.hud_batalha_xp_anim_bloqueada = true;
        global.hud_batalha_xp_anim_aguardando = false;
        if (array_length(global.hud_batalha_dialogo_fila) > 0)
        {
            var _apos_xp = scr_batalha_dialogo_pop();
            if (is_struct(_apos_xp))
                scr_batalha_dialogo_ativar_item(_apos_xp);
        }
    }
}

var _confirmar = keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(vk_space)
    || keyboard_check_pressed(ord("Z"))
    || keyboard_check_pressed(ord("z"));
var _cancelar = keyboard_check_pressed(vk_escape)
    || keyboard_check_pressed(vk_backspace)
    || keyboard_check_pressed(ord("X"))
    || keyboard_check_pressed(ord("x"));
var _clique_mouse = mouse_check_button_pressed(mb_left);
var _tecla_b = keyboard_check_pressed(ord("B"));

if (global.hud_batalha_dialogo_texto != "" || array_length(global.hud_batalha_dialogo_fila) > 0)
{
    if (variable_global_exists("hud_batalha_xp_anim_aguardando")
        && global.hud_batalha_xp_anim_aguardando)
        exit;

    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(ord("z")) || _clique_mouse)
    {
        if (variable_global_exists("hud_batalha_dialogo_xp_ao_avancar")
            && global.hud_batalha_dialogo_xp_ao_avancar)
        {
            global.hud_batalha_dialogo_xp_ao_avancar = false;
            global.hud_batalha_dialogo_texto = "";
            global.hud_batalha_xp_anim_bloqueada = false;
            global.hud_batalha_xp_anim_aguardando = true;
            global.hud_batalha_xp_anim_reiniciar = global.hud_batalha_dialogo_xp_reiniciar;
            global.hud_batalha_xp_anim_final = global.hud_batalha_dialogo_xp_final;
            global.hud_batalha_xp_anim.jogador.alvo =
                global.hud_batalha_dialogo_xp_alvo;
        }
        else if (array_length(global.hud_batalha_dialogo_fila) > 0)
        {
            var _proximo = scr_batalha_dialogo_pop();
            if (is_struct(_proximo))
            {
                scr_batalha_dialogo_ativar_item(_proximo);
                global.hud_batalha_dialogo_xp_alvo = _proximo.xp_alvo;
                global.hud_batalha_dialogo_xp_final = _proximo.xp_final;
                global.hud_batalha_dialogo_xp_reiniciar = _proximo.xp_reiniciar;
            }
        }
        else
        {
            global.hud_batalha_dialogo_texto = "";
            global.hud_batalha_dialogo_is_enemy = false;

            if (global.hud_batalha_fim_estado == "vitoria")
            {
                global.em_batalha = false;
                global.menu_treinador_aberto = false;
                global.menu_treinador_submenu = "";
                global.hud_batalha_dialogo_fila = [];
                global.hud_batalha_dialogo_texto = "";
                scr_grama_rearmar_encontros();
                if (instance_exists(treinador_atual_id)) with (treinador_atual_id) ja_derrotado = true;
                if (variable_global_exists("sala_antes_da_batalha")) room_goto(global.sala_antes_da_batalha);
            }
            else if (global.hud_batalha_fim_estado == "derrota")
            {
                global.hud_batalha_fim_estado = "nenhum";
                global.em_batalha = false;
                global.menu_treinador_aberto = false;
                global.menu_treinador_submenu = "";
                global.hud_batalha_dialogo_fila = [];
                global.hud_batalha_dialogo_texto = "";
                scr_grama_rearmar_encontros();
                scr_enfermeira_restaurar_equipe();
                if (variable_global_exists("ultima_enfermeira_room")
                    && global.ultima_enfermeira_room != noone)
                {
                    global.retorno_enfermeira_pendente = true;
                    room_goto(global.ultima_enfermeira_room);
                }
                else if (variable_global_exists("sala_antes_da_batalha"))
                {
                    room_goto(global.sala_antes_da_batalha);
                }
            }
        }
    }
    exit;
}

if (global.hud_batalha_menu_estado == "derrota")
{
    if (_confirmar || _clique_mouse)
    {
        global.hud_batalha_fim_estado = "nenhum";
        global.em_batalha = false;
        global.menu_treinador_aberto = false;
        global.menu_treinador_submenu = "";
        global.hud_batalha_dialogo_fila = [];
        global.hud_batalha_dialogo_texto = "";
        scr_grama_rearmar_encontros();
        scr_enfermeira_restaurar_equipe();
        if (variable_global_exists("ultima_enfermeira_room")
            && global.ultima_enfermeira_room != noone)
        {
            global.retorno_enfermeira_pendente = true;
            room_goto(global.ultima_enfermeira_room);
        }
        else if (variable_global_exists("sala_antes_da_batalha"))
        {
            room_goto(global.sala_antes_da_batalha);
        }
    }
    exit;
}

if (global.hud_batalha_menu_estado == "menu")
{
    var _indice_mouse = -1;
    var _mouse_movido = false;
    if (!variable_instance_exists(id, "hud_menu_mouse_x"))
    {
        hud_menu_mouse_x = mouse_x;
        hud_menu_mouse_y = mouse_y;
    }
    else
    {
        _mouse_movido = mouse_x != hud_menu_mouse_x || mouse_y != hud_menu_mouse_y;
        hud_menu_mouse_x = mouse_x;
        hud_menu_mouse_y = mouse_y;
    }
    if (room == cena_batalha)
    {
        var _opcoes_x = [66, 66, 66, 66];
        var _opcoes_y = [477, 610, 742, 876];
        var _opcoes_sprite = [hud_fight, hud_pkmn, hud_bag, hud_run];
        for (var _i_opcao = 0; _i_opcao < array_length(_opcoes_y); _i_opcao++)
        {
            var _largura_opcao = sprite_get_width(_opcoes_sprite[_i_opcao]);
            var _altura_opcao = sprite_get_height(_opcoes_sprite[_i_opcao]);
            if (mouse_x >= _opcoes_x[_i_opcao]
                && mouse_x <= _opcoes_x[_i_opcao] + _largura_opcao
                && mouse_y >= _opcoes_y[_i_opcao]
                && mouse_y <= _opcoes_y[_i_opcao] + _altura_opcao)
            {
                _indice_mouse = _i_opcao;
                if (_mouse_movido) global.hud_batalha_menu_index = _indice_mouse;
                break;
            }
        }

        if (keyboard_check_pressed(ord("W")))
            global.hud_batalha_menu_index = max(0, global.hud_batalha_menu_index - 1);
        else if (keyboard_check_pressed(ord("S")))
            global.hud_batalha_menu_index = min(3, global.hud_batalha_menu_index + 1);
    }
    else
    {
        var _menu_x = 1920 - 24 - 580;
        var _menu_y = 1280 - 24 - 150;
        var _start_x = _menu_x + 24;
        var _start_y = _menu_y + 38;
        var _option_w = 120;
        var _option_h = 74;
        var _gap = 16;

        if (mouse_x >= _start_x && mouse_x <= _start_x + (4 * _option_w) + (3 * _gap)
            && mouse_y >= _start_y && mouse_y <= _start_y + _option_h)
        {
            _indice_mouse = floor((mouse_x - _start_x) / (_option_w + _gap));
            _indice_mouse = clamp(_indice_mouse, 0, 3);
            global.hud_batalha_menu_index = _indice_mouse;
        }

        if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_up)
            || keyboard_check_pressed(ord("A")) || keyboard_check_pressed(ord("W")))
        {
            global.hud_batalha_menu_index = (global.hud_batalha_menu_index + 3) mod 4;
        }
        else if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_down)
            || keyboard_check_pressed(ord("D")) || keyboard_check_pressed(ord("S")))
        {
            global.hud_batalha_menu_index = (global.hud_batalha_menu_index + 1) mod 4;
        }
    }

    if (room != cena_batalha)
    {
        if (keyboard_check_pressed(ord("1"))) global.hud_batalha_menu_index = 0;
        if (keyboard_check_pressed(ord("2"))) global.hud_batalha_menu_index = 1;
        if (keyboard_check_pressed(ord("3"))) global.hud_batalha_menu_index = 2;
        if (keyboard_check_pressed(ord("4"))) global.hud_batalha_menu_index = 3;
    }
    if (mouse_check_button_pressed(mb_left) && _indice_mouse != -1)
    {
        global.hud_batalha_menu_index = _indice_mouse;
        _confirmar = true;
    }

    if (_confirmar)
    {
        if (room == cena_batalha && global.hud_batalha_substituicao_obrigatoria
            && global.hud_batalha_menu_index == 3)
        {
            show_debug_message(">> Nao e possivel fugir enquanto uma troca obrigatoria esta pendente.");
        }
        else
        {
            switch (global.hud_batalha_menu_index)
            {
                case 0:
                    global.hud_batalha_menu_estado = "fight";
                    break;
                case 1:
                    if (room == cena_batalha)
                    {
                        global.hud_batalha_menu_estado = "pokemon";
                        global.hud_batalha_pokemon_index = treinador_jogador.indice_ativo;
                    }
                    else
                    {
                        global.hud_batalha_menu_estado = "bag";
                    }
                    break;
                case 2:
                    if (room == cena_batalha)
                    {
                        global.hud_batalha_menu_estado = "bag";
                    }
                    else
                    {
                        global.hud_batalha_menu_estado = "pokemon";
                        global.hud_batalha_pokemon_index = treinador_jogador.indice_ativo;
                    }
                    break;
                case 3:
                    global.em_batalha = false;
                    global.menu_treinador_aberto = false;
                    global.menu_treinador_submenu = "";
                    scr_grama_rearmar_encontros();
                    if (variable_global_exists("sala_antes_da_batalha")) room_goto(global.sala_antes_da_batalha);
                    break;
            }
        }
    }
    exit;
}

if (_cancelar && !global.hud_batalha_substituicao_obrigatoria)
{
    global.hud_batalha_menu_estado = "menu";
    global.hud_batalha_menu_index = 0;
    exit;
}

if (global.hud_batalha_menu_estado == "bag")
{
    var _itens_bag = scr_mochila_obter_divisao(global.mochila.divisoes[global.menu_bag_divisao]);
    var _qtd_itens_bag = array_length(_itens_bag);
    global.menu_bag_item_index = clamp(global.hud_batalha_bag_index, 0, max(0, _qtd_itens_bag - 1));
    var _bag_camera = view_camera[0];
    var _bag_scale = (camera_get_view_width(_bag_camera) / 384) * 1.35;
    var _bag_x = camera_get_view_x(_bag_camera) + (190 * _bag_scale);
    var _bag_y = camera_get_view_y(_bag_camera) + (30 * _bag_scale);
    var _bag_mouse_x = (mouse_x - _bag_x) / _bag_scale;
    var _bag_mouse_y = (mouse_y - _bag_y) / _bag_scale;
    if (_bag_mouse_x >= 0 && _bag_mouse_x <= 145 && _bag_mouse_y >= 0 && _bag_mouse_y <= 150)
    {
        if (_bag_mouse_y >= 125 && _bag_mouse_x < 72)
        {
            global.menu_bag_divisao = (global.menu_bag_divisao + array_length(global.mochila.divisoes) - 1) mod array_length(global.mochila.divisoes);
            global.hud_batalha_bag_index = 0;
            global.menu_bag_item_index = 0;
        }
        else if (_bag_mouse_y >= 125 && _bag_mouse_x >= 72)
        {
            global.menu_bag_divisao = (global.menu_bag_divisao + 1) mod array_length(global.mochila.divisoes);
            global.hud_batalha_bag_index = 0;
            global.menu_bag_item_index = 0;
        }
        else if (_bag_mouse_y >= 30 && _bag_mouse_y < 114)
        {
            var _bag_mouse_index = clamp(floor((_bag_mouse_y - 30) / 21), 0, max(0, _qtd_itens_bag - 1));
            global.hud_batalha_bag_index = _bag_mouse_index;
            global.menu_bag_item_index = _bag_mouse_index;
            if (_clique_mouse) _confirmar = true;
        }
    }
    if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A")))
    {
        global.menu_bag_divisao = (global.menu_bag_divisao + array_length(global.mochila.divisoes) - 1) mod array_length(global.mochila.divisoes);
        global.hud_batalha_bag_index = 0;
        global.menu_bag_item_index = 0;
    }
    if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D")))
    {
        global.menu_bag_divisao = (global.menu_bag_divisao + 1) mod array_length(global.mochila.divisoes);
        global.hud_batalha_bag_index = 0;
        global.menu_bag_item_index = 0;
    }
    if (mouse_x >= 114 && mouse_x <= 970
        && mouse_y >= 180 && mouse_y <= 180 + (_qtd_itens_bag * 54))
    {
        global.hud_batalha_bag_index = clamp(floor((mouse_y - 180) / 54), 0, max(0, _qtd_itens_bag - 1));
        if (_clique_mouse) _confirmar = true;
    }
    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")))
    {
        global.hud_batalha_bag_index = max(0, global.hud_batalha_bag_index - 1);
        global.menu_bag_item_index = global.hud_batalha_bag_index;
    }
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
    {
        global.hud_batalha_bag_index = min(max(0, _qtd_itens_bag - 1), global.hud_batalha_bag_index + 1);
        global.menu_bag_item_index = global.hud_batalha_bag_index;
    }

    if (_confirmar)
    {
        if (_qtd_itens_bag > 0)
        {
            var _id_item_bag = _itens_bag[global.hud_batalha_bag_index];
            var _alvo_item = scr_get_monstro_ativo(treinador_ia);
            var _resultado_item;
            if (global.itens[$ _id_item_bag].utilidade == "captura")
            {
                if (!variable_struct_exists(treinador_ia, "eh_selvagem") || !treinador_ia.eh_selvagem)
                    _resultado_item = { sucesso: false, mensagem: "Nao e possivel capturar Pokemon de treinadores." };
                else
                    _resultado_item = scr_tentar_captura(_id_item_bag, _alvo_item, treinador_jogador, teste_turno);
                if (_resultado_item.sucesso && _resultado_item.capturou)
                {
                    scr_exibir_log_turno_equipe([{ tipo_acao: "item", mensagem: _resultado_item.mensagem,
                        is_enemy: false, hp_jogador: scr_get_monstro_ativo(treinador_jogador).hp_atual,
                        hp_inimigo: _alvo_item.hp_atual }]);
                    teste_batalha_acabou = true;
                    global.hud_batalha_fim_estado = "vitoria";
                    exit;
                }
            }
            else
            {
                global.hud_batalha_item_pendente = _id_item_bag;
                global.hud_batalha_menu_estado = "pokemon";
                global.hud_batalha_pokemon_index = treinador_jogador.indice_ativo;
                exit;
            }
            if (_resultado_item.sucesso)
            {
                var _log_item = scr_resolver_turno_equipe(treinador_jogador, treinador_ia,
                    { tipo: "item", mensagem: _resultado_item.mensagem });
                scr_exibir_log_turno_equipe(_log_item);
                global.hud_batalha_menu_estado = "menu";
                global.hud_batalha_menu_index = (room == cena_batalha) ? 2 : 1;
                if (!scr_equipe_tem_vivos(treinador_jogador))
                {
                    teste_batalha_acabou = true;
                    global.hud_batalha_fim_estado = "derrota";
                }
                else if (scr_get_monstro_ativo(treinador_jogador).esta_desmaiado)
                {
                    global.hud_batalha_substituicao_obrigatoria = true;
                    global.hud_batalha_menu_estado = "pokemon";
                    global.hud_batalha_pokemon_index = 0;
                }
                else
                {
                    teste_turno += 1;
                }
            }
            else
            {
                show_debug_message(_resultado_item.mensagem);
                global.hud_batalha_menu_estado = "bag";
            }
        }
    }
    exit;
}

if (global.hud_batalha_menu_estado == "pokemon_opcoes")
{
    var _opcao_y = 378;
    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")))
        global.hud_batalha_pokemon_opcao = max(0, global.hud_batalha_pokemon_opcao - 1);
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
        global.hud_batalha_pokemon_opcao = min(2, global.hud_batalha_pokemon_opcao + 1);

    if (mouse_x >= 1378 && mouse_x <= 1762 && mouse_y >= _opcao_y && mouse_y <= _opcao_y + 180)
    {
        global.hud_batalha_pokemon_opcao = clamp(floor((mouse_y - _opcao_y) / 60), 0, 2);
        if (_clique_mouse) _confirmar = true;
    }

    if (_tecla_b || _cancelar)
    {
        global.hud_batalha_menu_estado = "pokemon";
        exit;
    }

    if (_confirmar)
    {
        switch (global.hud_batalha_pokemon_opcao)
        {
            case 0:
                global.hud_batalha_menu_estado = "pokemon_sumario";
                break;
            case 1:
                if (!treinador_jogador.monstros[global.hud_batalha_pokemon_index].esta_desmaiado)
                {
                    var _indice_troca = global.hud_batalha_pokemon_index;
                    if (global.hud_batalha_substituicao_obrigatoria)
                    {
                        var _monstro_antigo_forcado = scr_get_monstro_ativo(treinador_jogador);
                        scr_resetar_status_temporarios(_monstro_antigo_forcado);
                        treinador_jogador.indice_ativo = _indice_troca;
                        var _monstro_novo_forcado = scr_get_monstro_ativo(treinador_jogador);
                        var _monstro_inimigo_forcado = scr_get_monstro_ativo(treinador_ia);
                        scr_exibir_log_turno_equipe([{
                            tipo_acao: "trocar",
                            treinador_nome: "Jogador",
                            saiu_nome: _monstro_antigo_forcado.nome,
                            entrou_nome: _monstro_novo_forcado.nome,
                            is_enemy: false,
                            hp_jogador: _monstro_novo_forcado.hp_atual,
                            hp_inimigo: _monstro_inimigo_forcado.hp_atual
                        }]);
                        global.hud_batalha_hp_anim.jogador.atual = _monstro_novo_forcado.hp_atual;
                        global.hud_batalha_hp_anim.jogador.alvo = _monstro_novo_forcado.hp_atual;
                    }
                    else
                    {
                        var _log_troca = scr_resolver_turno_equipe(treinador_jogador, treinador_ia,
                            { tipo: "trocar", novo_indice: _indice_troca });
                        scr_exibir_log_turno_equipe(_log_troca);
                    }
                    global.hud_batalha_substituicao_obrigatoria = false;
                    global.hud_batalha_fim_estado = "nenhum";
                    global.hud_batalha_menu_estado = "menu";
                    global.hud_batalha_menu_index = (room == cena_batalha) ? 1 : 2;
                    if (!teste_batalha_acabou)
                        teste_turno += 1;
                    if (!scr_equipe_tem_vivos(treinador_jogador))
                    {
                        teste_batalha_acabou = true;
                        global.hud_batalha_fim_estado = "derrota";
                    }
                    else if (scr_get_monstro_ativo(treinador_jogador).esta_desmaiado)
                    {
                        global.hud_batalha_substituicao_obrigatoria = true;
                        global.hud_batalha_menu_estado = "pokemon";
                        global.hud_batalha_pokemon_index = 0;
                    }
                }
                break;
            case 2:
                global.hud_batalha_menu_estado = "pokemon";
                break;
        }
    }
    exit;
}

if (global.hud_batalha_menu_estado == "pokemon_sumario")
{
    if (_tecla_b || _cancelar || (_clique_mouse && mouse_x >= 1540 && mouse_x <= 1740 && mouse_y >= 1000 && mouse_y <= 1080))
    {
        global.hud_batalha_menu_estado = "pokemon_opcoes";
    }
    exit;
}

if (global.hud_batalha_menu_estado == "pokemon")
{
    var _qtd_pokemon = array_length(treinador_jogador.monstros);
    for (var _mouse_i = 0; _mouse_i < _qtd_pokemon; _mouse_i++)
    {
        var _mouse_card_x = 146 + ((_mouse_i mod 2) * 754);
        var _mouse_card_y = 182 + (floor(_mouse_i / 2) * 194);
        if (mouse_x >= _mouse_card_x && mouse_x <= _mouse_card_x + 720
            && mouse_y >= _mouse_card_y && mouse_y <= _mouse_card_y + 170)
        {
            global.hud_batalha_pokemon_index = _mouse_i;
            if (_clique_mouse) _confirmar = true;
            break;
        }
    }
    if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_up)
        || keyboard_check_pressed(ord("A")) || keyboard_check_pressed(ord("W")))
    {
        global.hud_batalha_pokemon_index = max(0, global.hud_batalha_pokemon_index - 1);
    }
    if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_down)
        || keyboard_check_pressed(ord("D")) || keyboard_check_pressed(ord("S")))
    {
        global.hud_batalha_pokemon_index = min(_qtd_pokemon - 1, global.hud_batalha_pokemon_index + 1);
    }

    if (_confirmar)
    {
        var _novo_indice = global.hud_batalha_pokemon_index;
        if (_novo_indice >= 0 && _novo_indice < _qtd_pokemon
            && !treinador_jogador.monstros[_novo_indice].esta_desmaiado)
        {
            if (global.hud_batalha_item_pendente != "")
            {
                var _item_pendente = global.hud_batalha_item_pendente;
                var _resultado_item = scr_mochila_usar_item_em_batalha(_item_pendente,
                    treinador_jogador.monstros[_novo_indice]);
                global.hud_batalha_item_pendente = "";
                if (_resultado_item.sucesso)
                {
                    var _log_item = scr_resolver_turno_equipe(treinador_jogador, treinador_ia,
                        { tipo: "item", mensagem: _resultado_item.mensagem });
                    scr_exibir_log_turno_equipe(_log_item);
                    global.hud_batalha_menu_estado = "menu";
                    global.hud_batalha_menu_index = (room == cena_batalha) ? 2 : 1;
                    teste_turno += 1;
                }
                else
                {
                    show_debug_message(_resultado_item.mensagem);
                    global.hud_batalha_menu_estado = "bag";
                }
            }
            else
            {
                global.hud_batalha_pokemon_opcao = 0;
                global.hud_batalha_menu_estado = "pokemon_opcoes";
            }
        }
    }
    if (_tecla_b || _cancelar || (_clique_mouse && mouse_x >= 1660 && mouse_x <= 1740 && mouse_y >= 1000 && mouse_y <= 1080))
    {
        if (global.hud_batalha_item_pendente != "")
        {
            global.hud_batalha_item_pendente = "";
            global.hud_batalha_menu_estado = "bag";
        }
        else
        {
            global.hud_batalha_menu_estado = "menu";
            global.hud_batalha_menu_index = (room == cena_batalha) ? 1 : 2;
        }
    }
    exit;
}

if (keyboard_check_pressed(ord("C")))
{
    if (global.campo.clima == "nenhum") scr_definir_clima("sol", 5);
    else if (global.campo.clima == "sol") scr_definir_clima("chuva", 5);
    else if (global.campo.clima == "chuva") scr_definir_clima("tempestade_areia", 5);
    else if (global.campo.clima == "tempestade_areia") scr_definir_clima("neve", 5);
    else scr_definir_clima("nenhum", 0);
    scr_exibir_turno_equipe(teste_turno, treinador_jogador, treinador_ia);
}

if (keyboard_check_pressed(ord("K")))
{
    if (global.campo.terreno == "nenhum") scr_definir_terreno("eletrico", 5);
    else if (global.campo.terreno == "eletrico") scr_definir_terreno("herbaceo", 5);
    else if (global.campo.terreno == "herbaceo") scr_definir_terreno("psiquico", 5);
    else if (global.campo.terreno == "psiquico") scr_definir_terreno("nebuloso", 5);
    else scr_definir_terreno("nenhum", 0);
    scr_exibir_turno_equipe(teste_turno, treinador_jogador, treinador_ia);
}

if (pendente_substituicao)
{
    var _slot_escolhido = -1;
    if (keyboard_check_pressed(vk_f1)) _slot_escolhido = 0;
    if (keyboard_check_pressed(vk_f2)) _slot_escolhido = 1;
    if (keyboard_check_pressed(vk_f3)) _slot_escolhido = 2;
    if (keyboard_check_pressed(vk_f4)) _slot_escolhido = 3;

    if (_slot_escolhido != -1)
    {
        var _res = scr_aprender_movimento(monstro_pendente, movimento_pendente_id, _slot_escolhido);
        show_debug_message(">> " + monstro_pendente.nome + " esqueceu " + global.movimentos[$ _res.antigo_id].nome + " e aprendeu " + global.movimentos[$ movimento_pendente_id].nome + "!");
        pendente_substituicao = false;
        if (!teste_batalha_acabou) scr_exibir_turno_equipe(teste_turno, treinador_jogador, treinador_ia);
    }
    else if (keyboard_check_pressed(vk_escape))
    {
        show_debug_message(">> " + monstro_pendente.nome + " não aprendeu " + global.movimentos[$ movimento_pendente_id].nome + ".");
        pendente_substituicao = false;
        if (!teste_batalha_acabou) scr_exibir_turno_equipe(teste_turno, treinador_jogador, treinador_ia);
    }
    exit;
}

if (!teste_batalha_acabou)
{
    var _acao = scr_jogador_escolher_acao(treinador_jogador);

    if (_acao.tipo != "nenhum")
    {
        var _xp_anim_inicio_turno = global.hud_batalha_xp_anim.jogador.atual;
        var _log = scr_resolver_turno_equipe(treinador_jogador, treinador_ia, _acao);
        scr_exibir_log_turno_equipe(_log);
        if (room == cena_batalha && _acao.tipo == "atacar")
            global.hud_batalha_menu_estado = "menu";
        var _p1_ativo = scr_get_monstro_ativo(treinador_jogador);
        var _inimigo_desmaiou = false;
        var _jogador_desmaiou = false;
        var _xp_do_jogador = false;
        var _acao_desmaio_inimigo = undefined;
        var _acao_desmaio_jogador = undefined;

        for (var _l = 0; _l < array_length(_log); _l++)
        {
            var _item = _log[_l];
            if (!variable_struct_exists(_item, "desmaiou") || !_item.desmaiou)
                continue;

            var _is_enemy_action = variable_struct_exists(_item, "is_enemy") && _item.is_enemy;
            var _alvo_desmaiado_nome = variable_struct_exists(_item, "alvo_nome")
                ? _item.alvo_nome : "O Pokémon";
            if (_is_enemy_action)
            {
                _jogador_desmaiou = true;
                _acao_desmaio_jogador = _item;
            }
            else
            {
                _inimigo_desmaiou = true;
                _acao_desmaio_inimigo = _item;
            }

            scr_batalha_dialogo_enfileirar_item(
                _alvo_desmaiado_nome + " desmaiou!",
                _item,
                _is_enemy_action,
                false,
                true
            );

            var _item_tem_xp = !_is_enemy_action
                && variable_struct_exists(_item, "novos_movimentos");
            _xp_do_jogador = _xp_do_jogador || _item_tem_xp;

            if (!_item_tem_xp)
                continue;

            var _progresso_xp_final = scr_progresso_xp_nivel(_p1_ativo);
            var _subiu_nivel = _item_tem_xp
                && variable_struct_exists(_item, "subiu_nivel") && _item.subiu_nivel;
            var _indice_desmaio = array_length(global.hud_batalha_dialogo_fila) - 1;
            global.hud_batalha_dialogo_fila[_indice_desmaio].aguarda_xp_ao_avancar = true;
            global.hud_batalha_dialogo_fila[_indice_desmaio].xp_alvo =
                _subiu_nivel ? 1 : _progresso_xp_final;
            global.hud_batalha_dialogo_fila[_indice_desmaio].xp_final = _progresso_xp_final;
            global.hud_batalha_dialogo_fila[_indice_desmaio].xp_reiniciar = _subiu_nivel;

            if (_item_tem_xp && _subiu_nivel)
            {
                scr_batalha_dialogo_enfileirar_item(
                    _item.atacante_nome + " subiu para o nível "
                        + string(_item.nivel_novo) + "!",
                    _item,
                    false,
                    false,
                    false
                );
            }

            if (_item_tem_xp && variable_struct_exists(_item, "evoluiu") && _item.evoluiu)
            {
                scr_batalha_dialogo_enfileirar_item(
                    "Parabéns! " + _item.evolucao_info.nome_antigo + " se tornou "
                        + _item.evolucao_info.nome_novo + "!",
                    _item,
                    false,
                    false,
                    false
                );
            }

            if (_item_tem_xp && variable_struct_exists(_item, "novos_movimentos"))
            {
                for (var _m = 0; _m < array_length(_item.novos_movimentos); _m++)
                {
                    var _novo_id = _item.novos_movimentos[_m];
                    var _monstro_que_ganhou_xp = scr_get_monstro_ativo(treinador_jogador);
                    if (scr_pokemon_tem_movimento(_monstro_que_ganhou_xp, _novo_id)) continue;
                    var _nome_golpe = global.movimentos[$ _novo_id].nome;

                    if (array_length(_monstro_que_ganhou_xp.movimentos) < 4)
                    {
                        scr_aprender_movimento(_monstro_que_ganhou_xp, _novo_id);
                        scr_batalha_dialogo_enfileirar_item(
                            _monstro_que_ganhou_xp.nome + " aprendeu " + _nome_golpe + "!",
                            _item,
                            false,
                            false,
                            false
                        );
                    }
                    else
                    {
                        scr_batalha_dialogo_enfileirar_item(
                            _monstro_que_ganhou_xp.nome + " quer aprender " + _nome_golpe
                                + ", mas não há espaço para outro ataque.",
                            _item,
                            false,
                            false,
                            false
                        );
                    }
                }
            }
        }

        if (_p1_ativo.esta_desmaiado && !_jogador_desmaiou)
        {
            _jogador_desmaiou = true;
            _acao_desmaio_jogador = {
                alvo_nome: _p1_ativo.nome,
                is_enemy: true,
                hp_jogador: _p1_ativo.hp_atual,
                hp_inimigo: scr_get_monstro_ativo(treinador_ia).hp_atual
            };
            scr_batalha_dialogo_enfileirar_item(
                _p1_ativo.nome + " desmaiou!",
                _acao_desmaio_jogador,
                true,
                false,
                true
            );
        }

        if (_xp_do_jogador)
        {
            global.hud_batalha_xp_anim_bloqueada = true;
            global.hud_batalha_xp_anim_aguardando = false;
            global.hud_batalha_xp_anim.jogador.atual = _xp_anim_inicio_turno;
            global.hud_batalha_xp_anim.jogador.alvo = _xp_anim_inicio_turno;
        }

        if (_inimigo_desmaiou)
        {
            var _proximos_inimigos = [];
            for (var _i_inimigo = 0; _i_inimigo < array_length(treinador_ia.monstros); _i_inimigo++)
            {
                if (!treinador_ia.monstros[_i_inimigo].esta_desmaiado)
                    array_push(_proximos_inimigos, _i_inimigo);
            }

            if (array_length(_proximos_inimigos) > 0
                && (!variable_struct_exists(treinador_ia, "eh_selvagem") || !treinador_ia.eh_selvagem))
            {
                var _indice_inimigo_seguinte =
                    _proximos_inimigos[irandom(array_length(_proximos_inimigos) - 1)];
                var _nome_treinador = "O treinador";
                if (instance_exists(treinador_atual_id))
                {
                    if (variable_instance_exists(treinador_atual_id, "nome_treinador"))
                        _nome_treinador = variable_instance_get(treinador_atual_id, "nome_treinador");
                    else if (variable_instance_exists(treinador_atual_id, "nome"))
                        _nome_treinador = variable_instance_get(treinador_atual_id, "nome");
                }
                var _proximo_inimigo = treinador_ia.monstros[_indice_inimigo_seguinte];
                scr_batalha_dialogo_enfileirar_item(
                    _nome_treinador + " enviou " + _proximo_inimigo.nome + "!",
                    _acao_desmaio_inimigo,
                    true,
                    false,
                    true,
                    false,
                    0,
                    0,
                    false,
                    _indice_inimigo_seguinte
                );
            }
            else if (array_length(_proximos_inimigos) == 0)
            {
                var _texto_sem_pokemon = (variable_struct_exists(treinador_ia, "eh_selvagem")
                    && treinador_ia.eh_selvagem)
                    ? "O Pokémon selvagem não tem mais energia para lutar!"
                    : "O treinador não tem mais Pokémon restantes!";
                scr_batalha_dialogo_enfileirar_item(
                    _texto_sem_pokemon,
                    _acao_desmaio_inimigo,
                    true,
                    false,
                    false
                );
                if (scr_equipe_tem_vivos(treinador_jogador))
                {
                    scr_batalha_dialogo_enfileirar_item(
                        "Jogador venceu a luta!",
                        _acao_desmaio_inimigo,
                        false,
                        false,
                        false
                    );
                }
            }
        }

        if (_jogador_desmaiou && !scr_equipe_tem_vivos(treinador_jogador))
        {
            global.hud_batalha_fim_estado = "derrota";
            teste_batalha_acabou = true;
            scr_batalha_dialogo_enfileirar_item(
                "Jogador não possui mais Pokémon!",
                _acao_desmaio_jogador,
                false,
                false,
                false
            );
            scr_batalha_dialogo_enfileirar_item(
                "Jogador foi derrotado!",
                _acao_desmaio_jogador,
                false,
                false,
                false
            );
        }

        if (!scr_equipe_tem_vivos(treinador_ia)
            && scr_equipe_tem_vivos(treinador_jogador))
        {
            teste_batalha_acabou = true;
            global.hud_batalha_fim_estado = "vitoria";
        }
        else if (scr_get_monstro_ativo(treinador_jogador).esta_desmaiado
            && scr_equipe_tem_vivos(treinador_jogador))
        {
            global.hud_batalha_substituicao_obrigatoria = true;
            global.hud_batalha_menu_estado = "pokemon";
            global.hud_batalha_pokemon_index = 0;
        }
        else if (!scr_equipe_tem_vivos(treinador_jogador))
        {
            teste_batalha_acabou = true;
            global.hud_batalha_fim_estado = "derrota";
        }
        else if (!pendente_substituicao)
        {
            teste_turno += 1;
            scr_exibir_turno_equipe(teste_turno, treinador_jogador, treinador_ia);
        }
    }
}
