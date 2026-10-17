// =============================================================================
// SCR_DEBUG_LOGS: Logs de console e exibicao formatada de turnos e status
// Funcoes de HUD e renderizacao visual foram migradas para scr_hud_batalha.gml
// =============================================================================

function scr_exibir_turno_equipe(turno, treinador_jogador, treinador_ia)
{
    var _p1 = scr_get_monstro_ativo(treinador_jogador);
    var _p2 = scr_get_monstro_ativo(treinador_ia);

    var _st_p1 = (_p1.status != "nenhum") ? " [" + string_upper(_p1.status) + "]" : "";
    var _st_p2 = (_p2.status != "nenhum") ? " [" + string_upper(_p2.status) + "]" : "";

    show_debug_message("");
    show_debug_message("=======================================");
    show_debug_message("TURNO " + string(turno));
    show_debug_message("CLIMA: " + string_upper(global.campo.clima) + " (" + string(global.campo.turnos_clima) + "t) | TERRENO: " + string_upper(global.campo.terreno) + " (" + string(global.campo.turnos_terreno) + "t)");
    show_debug_message("=======================================");
    show_debug_message("SEU POKÃ‰MON: " + _p1.nome + " [" + string(_p1.genero) + "]" + _st_p1 + " - HP: " + string(_p1.hp_atual) + "/" + string(_p1.hp_max) + " | Nv: " + string(_p1.nivel) + " | Hab: " + _p1.habilidade);
    show_debug_message("OPONENTE:    " + _p2.nome + " [" + string(_p2.genero) + "]" + _st_p2 + " - HP: " + string(_p2.hp_atual) + "/" + string(_p2.hp_max) + " | Nv: " + string(_p2.nivel) + " | Hab: " + _p2.habilidade);
    
    show_debug_message("--- Golpes (1-4) ---");
    for (var _i = 0; _i < array_length(_p1.movimentos); _i++)
    {
        var _mov_inst = _p1.movimentos[_i];
        var _mov_dados = global.movimentos[$ _mov_inst.movimento_id];
        show_debug_message(string(_i + 1) + ") " + _mov_dados.nome + " (PP: " + string(_mov_inst.pp_atual) + "/" + string(_mov_dados.pp_max) + ")");
    }

    show_debug_message("--- Trocar PokÃ©mon da Equipe (5-9) ---");
    var _tecla_troca = 5;
    for (var _i = 0; _i < array_length(treinador_jogador.monstros); _i++)
    {
        var _m = treinador_jogador.monstros[_i];
        var _st_m = (_m.status != "nenhum") ? " [" + string_upper(_m.status) + "]" : "";
        var _status = _m.esta_desmaiado ? "[DESMAIADO]" : (_i == treinador_jogador.indice_ativo ? "[EM CAMPO]" : "[OK]");

        if (_i == treinador_jogador.indice_ativo)
        {
            show_debug_message("Em campo -> " + _m.nome + _st_m + " (HP: " + string(_m.hp_atual) + "/" + string(_m.hp_max) + ") " + _status);
        }
        else
        {
            show_debug_message("Tecla " + string(_tecla_troca) + " -> " + _m.nome + _st_m + " (HP: " + string(_m.hp_atual) + "/" + string(_m.hp_max) + ") " + _status);
            _tecla_troca++;
        }
    }

	show_debug_message("---------------------------------------");
    show_debug_message("Atalhos de Teste: [I] Info Completa | [C] Ciclar Clima | [K] Ciclar Terreno | [T] Ciclar Status | [R] Reset");
    show_debug_message("Escolha uma aÃ§Ã£o...");

}

function scr_exibir_log_turno_equipe(log)
{
    scr_batalha_enfileirar_log(log);

    for (var _i = 0; _i < array_length(log); _i++)
    {
        var _item = log[_i];

        if (variable_struct_exists(_item, "tipo_acao") && _item.tipo_acao == "item")
        {
            show_debug_message(">> " + _item.mensagem);
            continue;
        }

        if (variable_struct_exists(_item, "tipo_acao") && _item.tipo_acao == "trocar")
        {
            show_debug_message(">> " + _item.treinador_nome + " recolheu " + _item.saiu_nome + " e enviou " + _item.entrou_nome + "!");
            continue;
        }

        if (variable_struct_exists(_item, "tipo_acao") && _item.tipo_acao == "status_dano")
        {
            show_debug_message(">> " + _item.mensagem);
            continue;
        }

        if (variable_struct_exists(_item, "tipo_acao") && _item.tipo_acao == "erro")
        {
            show_debug_message(">> " + _item.mensagem);
            continue;
        }

        scr_exibir_log_turno([_item]);
    }
}

function scr_exibir_ivs_nature(monstro)
{
    var _st = (monstro.status != "nenhum") ? " | Status: " + string_upper(monstro.status) : "";
    show_debug_message("--- " + monstro.nome + " ---");
    show_debug_message("GÃªnero: " + string(monstro.genero) + " | Habilidade: " + monstro.habilidade + _st);
    show_debug_message("Nature: " + monstro.nature.nome + " (Aumenta: " + monstro.nature.aumenta + " | Diminui: " + monstro.nature.diminui + ")");
    show_debug_message("IVs -> HP: " + string(monstro.ivs.hp) + " | ATK: " + string(monstro.ivs.atk) + " | DEF: " + string(monstro.ivs.def) + " | ATK ESP: " + string(monstro.ivs.atk_esp) + " | DEF ESP: " + string(monstro.ivs.def_esp) + " | SPD: " + string(monstro.ivs.spd));
}

function scr_exibir_log_turno(log)
{
    for (var _i = 0; _i < array_length(log); _i++)
    {
        var _acao = log[_i];

        if (!_acao.sucesso)
        {
            show_debug_message(_acao.atacante_nome + " tentou usar " + _acao.movimento_nome + ", mas nÃ£o pÃ´de (" + _acao.motivo + ")");
            continue;
        }

        if (!_acao.acertou)
        {
            if (variable_struct_exists(_acao, "motivo") && _acao.motivo == "apaixonado")
            {
                show_debug_message(_acao.atacante_nome + " estÃ¡ apaixonado e nÃ£o conseguiu atacar!");
            }
            else
            {
                show_debug_message(_acao.atacante_nome + " usou " + _acao.movimento_nome + ", mas errou!");
            }
            continue;
        }

        if (_acao.categoria == "status")
        {
            show_debug_message(_acao.atacante_nome + " usou " + _acao.movimento_nome + "!");

            switch (_acao.tipo_efeito)
            {
                case "status":
                    show_debug_message(_acao.aplicou
                        ? ">> " + _acao.alvo_nome + " foi afetado por " + string_upper(_acao.status_id) + "!"
                        : ">> NÃ£o teve efeito em " + _acao.alvo_nome + ".");
                    break;

                case "cura":
                    show_debug_message(">> " + _acao.atacante_nome + " recuperou " + string(_acao.valor_curado) + " de HP!");
                    break;

                case "attract":
                    show_debug_message(">> " + _acao.alvo_nome + " ficou apaixonado!");
                    break;

                case "buff":
                    show_debug_message(_acao.mudou
                        ? ">> " + _acao.stat + " de " + _acao.atacante_nome + " aumentou! (estÃ¡gio " + string(_acao.estagio_novo) + ")"
                        : ">> NÃ£o teve efeito (estÃ¡gio jÃ¡ mÃ¡ximo).");
                    break;

                case "debuff":
                    show_debug_message(_acao.mudou
                        ? ">> " + _acao.stat + " do oponente diminuiu! (estÃ¡gio " + string(_acao.estagio_novo) + ")"
                        : ">> NÃ£o teve efeito (estÃ¡gio jÃ¡ mÃ­nimo).");
                    break;

                case "volatil":
                    show_debug_message(_acao.aplicou
                        ? ">> " + _acao.alvo_nome + " foi afetado (" + _acao.estado_id + ")!"
                        : ">> NÃ£o teve efeito em " + _acao.alvo_nome + ".");
                    break;

                case "perish_song":
                    show_debug_message(">> Todos os PokÃ©mon em campo que ouviram a mÃºsica vÃ£o desmaiar em 3 turnos!");
                    break;

                case "falhou":
                    show_debug_message(">> Mas o movimento falhou!");
                    break;
            }

            continue;
        }

        show_debug_message(_acao.atacante_nome + " usou " + _acao.movimento_nome + " em " + _acao.alvo_nome + " causando " + string(_acao.dano) + " de dano.");

        if (_acao.critico) show_debug_message(">> Foi um golpe crÃ­tico!");
        if (_acao.efetividade > 1) show_debug_message(">> Foi super efetivo!");
        else if (_acao.efetividade < 1 && _acao.efetividade > 0) show_debug_message(">> NÃ£o foi muito efetivo...");
        else if (_acao.efetividade == 0) show_debug_message(">> NÃ£o afetou o alvo...");

        if (variable_struct_exists(_acao, "ativou_cute_charm") && _acao.ativou_cute_charm)
        {
            show_debug_message(">> " + _acao.atacante_nome + " se apaixonou por causa de Cute Charm!");
        }

        if (variable_struct_exists(_acao, "efeito_secundario_info") && _acao.efeito_secundario_info.ativou)
        {
            var _es = _acao.efeito_secundario_info;
            switch (_es.tipo)
            {
                case "status":  show_debug_message(">> " + _es.alvo_nome + " foi afetado por " + string_upper(_es.status_id) + "! (efeito secundÃ¡rio)"); break;
                case "buff":    show_debug_message(">> " + _es.stat + " de " + _es.alvo_nome + " aumentou! (efeito secundÃ¡rio)"); break;
                case "debuff":  show_debug_message(">> " + _es.stat + " de " + _es.alvo_nome + " diminuiu! (efeito secundÃ¡rio)"); break;
                case "volatil": show_debug_message(">> " + _es.alvo_nome + " foi afetado (" + _es.estado_id + ")! (efeito secundÃ¡rio)"); break;
                case "flinch":  show_debug_message(">> " + _es.alvo_nome + " hesitou! (efeito secundÃ¡rio)"); break;
            }
        }

        if (_acao.subiu_nivel) show_debug_message(">> " + _acao.atacante_nome + " subiu para o nÃ­vel " + string(_acao.nivel_novo) + "! (XP: " + string(_acao.xp_atual) + "/" + string(_acao.xp_prox_nivel) + ")");

        if (variable_struct_exists(_acao, "evoluiu") && _acao.evoluiu)
        {
            show_debug_message(">> O que? " + _acao.evolucao_info.nome_antigo + " estÃ¡ evoluindo...");
            show_debug_message(">> ParabÃ©ns! Seu " + _acao.evolucao_info.nome_antigo + " se tornou " + _acao.evolucao_info.nome_novo + "!");

            for (var _n = 0; _n < array_length(_acao.evolucao_info.novos_movimentos); _n++)
            {
                var _nome_mov = global.movimentos[$ _acao.evolucao_info.novos_movimentos[_n]].nome;
                show_debug_message(">> " + _acao.evolucao_info.nome_novo + " aprendeu " + _nome_mov + "!");
            }
        }

        if (_acao.desmaiou) show_debug_message(">> " + _acao.alvo_nome + " desmaiou!");
    }
}

function scr_exibir_info_completa(monstro)
{
    show_debug_message("");
    show_debug_message("========== INFORMAÃ‡Ã•ES COMPLETAS ==========");
    show_debug_message("NOME: " + monstro.nome + " | GÃŠNERO: " + string(monstro.genero));
    show_debug_message("NÃVEL: " + string(monstro.nivel) + " | XP: " + string(monstro.xp) + " / " + string(monstro.xp_prox_nivel));
    show_debug_message("HABILIDADE: " + monstro.habilidade);
    show_debug_message("NATURE: " + monstro.nature.nome + " (+ " + monstro.nature.aumenta + " / - " + monstro.nature.diminui + ")");
    
    var _st_nocivo = (monstro.status != "nenhum") ? string_upper(monstro.status) : "Nenhum";
    var _apaixonado = (variable_struct_exists(monstro, "apaixonado") && monstro.apaixonado) ? "Sim" : "NÃ£o";
    show_debug_message("STATUS NOCIVO: " + _st_nocivo + " | APAIXONADO: " + _apaixonado);
    
    show_debug_message("--- STATUS DE BATALHA ---");
    show_debug_message("HP:  " + string(monstro.hp_atual) + " / " + string(monstro.hp_max) + " (IV: " + string(monstro.ivs.hp) + ")");
    
    // Calcula os status efetivos puxando as funÃ§Ãµes que aplicam os multiplicadores de estÃ¡gio
    var _atk_efetivo = scr_get_stat_efetivo(monstro, "atk");
    var _def_efetivo = scr_get_stat_efetivo(monstro, "def");
    var _spa_efetivo = scr_get_stat_efetivo(monstro, "atk_esp");
    var _spd_efetivo = scr_get_stat_efetivo(monstro, "def_esp");
    var _spe_efetiva = scr_get_spd_com_status(monstro); // FunÃ§Ã£o que vocÃª jÃ¡ possui que checa paralisia
    
    show_debug_message("ATK: " + string(_atk_efetivo) + " (Base mod: EstÃ¡gio " + string(monstro.estagios.atk) + " | IV: " + string(monstro.ivs.atk) + ")");
    show_debug_message("DEF: " + string(_def_efetivo) + " (Base mod: EstÃ¡gio " + string(monstro.estagios.def) + " | IV: " + string(monstro.ivs.def) + ")");
    show_debug_message("SPA: " + string(_spa_efetivo) + " (Base mod: EstÃ¡gio " + string(monstro.estagios.atk_esp) + " | IV: " + string(monstro.ivs.atk_esp) + ")");
    show_debug_message("SPD: " + string(_spd_efetivo) + " (Base mod: EstÃ¡gio " + string(monstro.estagios.def_esp) + " | IV: " + string(monstro.ivs.def_esp) + ")");
    show_debug_message("SPE: " + string(_spe_efetiva) + " (Base mod: EstÃ¡gio " + string(monstro.estagios.spd) + " | IV: " + string(monstro.ivs.spd) + ")");
    
    show_debug_message("--- MOVIMENTOS ---");
    for (var _i = 0; _i < array_length(monstro.movimentos); _i++)
    {
        var _mov_inst = monstro.movimentos[_i];
        var _mov_dados = global.movimentos[$ _mov_inst.movimento_id];
        show_debug_message(string(_i + 1) + ") " + _mov_dados.nome + " | PP: " + string(_mov_inst.pp_atual) + "/" + string(_mov_dados.pp_max) + " | Categoria: " + _mov_dados.categoria);
    }
    show_debug_message("===========================================");
    show_debug_message("");
}
