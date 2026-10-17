function scr_resolver_turno_equipe(treinador_jogador, treinador_ia, acao_jogador)
{
    var _log = [];
    var _p1 = scr_get_monstro_ativo(treinador_jogador);
    var _p2 = scr_get_monstro_ativo(treinador_ia);

    var _indice_ia = scr_ia_escolher_movimento(_p2, _p1);
    var _acao_ia = { tipo: "atacar", indice: _indice_ia };

    // Função que "tira uma foto" do HP exato após cada golpe
    var _push_log = function(arr, obj, p1, p2) {
        obj.hp_jogador = p1.hp_atual;
        obj.hp_inimigo = p2.hp_atual;
        array_push(arr, obj);
    };

    if (acao_jogador.tipo == "trocar")
    {
        if (acao_jogador.novo_indice < 0 || acao_jogador.novo_indice >= array_length(treinador_jogador.monstros) ||
            acao_jogador.novo_indice == treinador_jogador.indice_ativo || treinador_jogador.monstros[acao_jogador.novo_indice].esta_desmaiado)
        {
            _push_log(_log, { tipo_acao: "erro", mensagem: "Troca inválida.", is_enemy: false }, _p1, _p2);
            return _log;
        }

        if (!_p1.esta_desmaiado && _p1.estados_volateis.preso.ativo)
        {
            _push_log(_log, { tipo_acao: "erro", mensagem: _p1.nome + " está preso e não pode ser trocado!", is_enemy: false }, _p1, _p2);
            return _log;
        }

        var _monstro_antigo = scr_get_monstro_ativo(treinador_jogador);
        scr_resetar_status_temporarios(_monstro_antigo);
        treinador_jogador.indice_ativo = acao_jogador.novo_indice;
        var _novo_monstro = scr_get_monstro_ativo(treinador_jogador);
        _p1 = _novo_monstro;

        if (_p2.apaixonado) _p2.apaixonado = false;
        if (_p2.estados_volateis.leech_seed && _p2.estados_volateis.leech_seed_de == _monstro_antigo)
            _p2.estados_volateis.leech_seed_de = _novo_monstro;

        _push_log(_log, { tipo_acao: "trocar", treinador_nome: "Jogador", saiu_nome: _monstro_antigo.nome, entrou_nome: _novo_monstro.nome, is_enemy: false }, _p1, _p2);

        if (_acao_ia.indice >= 0 && !_p2.esta_desmaiado)
        {
            var _st_p2 = scr_pode_atacar_status(_p2);
            var _vol_p2 = _st_p2.pode ? scr_pode_atacar_volatil(_p2) : { pode: true, motivo: "" };
            if (_st_p2.pode && _vol_p2.pode)
            {
                var _res_troca_ia = scr_executar_acao(_p2, _novo_monstro, _acao_ia.indice);
                _res_troca_ia.is_enemy = true;
                _push_log(_log, _res_troca_ia, _p1, _p2);
            }
            else
            {
                _push_log(_log, { atacante_nome: _p2.nome, movimento_nome: "", sucesso: false, motivo: !_st_p2.pode ? _st_p2.motivo : _vol_p2.motivo, is_enemy: true }, _p1, _p2);
            }
        }

        if (_p1.esta_desmaiado || _p2.esta_desmaiado) return _log;
    }
    else if (acao_jogador.tipo == "item")
    {
        _push_log(_log, { tipo_acao: "item", mensagem: acao_jogador.mensagem, is_enemy: false }, _p1, _p2);

        if (_acao_ia.indice >= 0 && !_p2.esta_desmaiado)
        {
            var _st_item_p2 = scr_pode_atacar_status(_p2);
            var _vol_item_p2 = _st_item_p2.pode ? scr_pode_atacar_volatil(_p2) : { pode: true, motivo: "" };
            if (_st_item_p2.pode && _vol_item_p2.pode)
            {
                var _res_item_ia = scr_executar_acao(_p2, _p1, _acao_ia.indice);
                _res_item_ia.is_enemy = true;
                _push_log(_log, _res_item_ia, _p1, _p2);
            }
            else
            {
                _push_log(_log, { atacante_nome: _p2.nome, movimento_nome: "", sucesso: false,
                    motivo: !_st_item_p2.pode ? _st_item_p2.motivo : _vol_item_p2.motivo, is_enemy: true }, _p1, _p2);
            }
        }

        if (_p1.esta_desmaiado || _p2.esta_desmaiado) return _log;
    }
    else
    {
        var _ordem = scr_decidir_ordem_turno(_p1, acao_jogador.indice, _p2, _acao_ia.indice);
        var _primeiro = _ordem[0];
        var _segundo = _ordem[1];
        var _ind_primeiro = (_primeiro == _p1) ? acao_jogador.indice : _acao_ia.indice;
        var _ind_segundo = (_segundo == _p1) ? acao_jogador.indice : _acao_ia.indice;
        var _alvo_primeiro = (_primeiro == _p1) ? _p2 : _p1;
        var _alvo_segundo = (_segundo == _p1) ? _p2 : _p1;

        // --- 1º ATACANTE ---
        var _st_primeiro = scr_pode_atacar_status(_primeiro);
        var _vol_primeiro = _st_primeiro.pode ? scr_pode_atacar_volatil(_primeiro) : { pode: true, motivo: "" };
        
        if (_st_primeiro.pode && _vol_primeiro.pode)
        {
            var _res_primeiro = scr_executar_acao(_primeiro, _alvo_primeiro, _ind_primeiro);
            _res_primeiro.is_enemy = (_primeiro == _p2);
            _push_log(_log, _res_primeiro, _p1, _p2);
        }
        else
        {
            _push_log(_log, { atacante_nome: _primeiro.nome, movimento_nome: "", sucesso: false, motivo: !_st_primeiro.pode ? _st_primeiro.motivo : _vol_primeiro.motivo, is_enemy: (_primeiro == _p2) }, _p1, _p2);
        }

        if (_alvo_primeiro.esta_desmaiado) return _log;

        // --- 2º ATACANTE ---
        var _st_segundo = scr_pode_atacar_status(_segundo);
        var _vol_segundo = _st_segundo.pode ? scr_pode_atacar_volatil(_segundo) : { pode: true, motivo: "" };

        if (_st_segundo.pode && _vol_segundo.pode)
        {
            var _res_segundo = scr_executar_acao(_segundo, _alvo_segundo, _ind_segundo);
            _res_segundo.is_enemy = (_segundo == _p2);
            _push_log(_log, _res_segundo, _p1, _p2);
        }
        else
        {
            _push_log(_log, { atacante_nome: _segundo.nome, movimento_nome: "", sucesso: false, motivo: !_st_segundo.pode ? _st_segundo.motivo : _vol_segundo.motivo, is_enemy: (_segundo == _p2) }, _p1, _p2);
        }

        if (_alvo_segundo.esta_desmaiado) return _log;
    }

    // --- STATUS E CLIMA ---
    var _monstros_fim = [_p1, _p2];
    for (var _i = 0; _i < array_length(_monstros_fim); _i++)
    {
        var _m = _monstros_fim[_i];
        if (_m.esta_desmaiado) continue;
        if (_m.status != "nenhum")
        {
            var _msg_status = scr_processar_dano_status_fim_turno(_m);
            if (_msg_status != "") _push_log(_log, { tipo_acao: "status_dano", mensagem: _msg_status, is_enemy: (_m == _p2) }, _p1, _p2);
        }
        if (_m.esta_desmaiado) continue;
        var _msgs_volateis = scr_processar_estados_volateis_fim_turno(_m);
        for (var _v = 0; _v < array_length(_msgs_volateis); _v++)
        {
            _push_log(_log, { tipo_acao: "status_dano", mensagem: _msgs_volateis[_v], is_enemy: (_m == _p2) }, _p1, _p2);
        }
    }

    var _log_campo = scr_processar_fim_turno_campo(treinador_jogador, treinador_ia);
    for (var _c = 0; _c < array_length(_log_campo); _c++)
    {
        _push_log(_log, { tipo_acao: "status_dano", mensagem: _log_campo[_c].mensagem, is_enemy: false }, _p1, _p2);
    }

    return _log;
}

function scr_decidir_ordem_turno(jogador, indice_jogador, inimigo, indice_ia)
{
    var _prioridade_jogador = scr_get_prioridade_movimento(jogador, indice_jogador);
    var _prioridade_inimigo = scr_get_prioridade_movimento(inimigo, indice_ia);

    if (_prioridade_jogador != _prioridade_inimigo)
    {
        return (_prioridade_jogador > _prioridade_inimigo) ? [jogador, inimigo] : [inimigo, jogador];
    }

    var _spd_jogador = scr_get_spd_com_status(jogador);
    var _spd_inimigo = scr_get_spd_com_status(inimigo);

    if (_spd_jogador > _spd_inimigo) return [jogador, inimigo];
    else if (_spd_inimigo > _spd_jogador) return [inimigo, jogador];
    else return (irandom(1) == 0) ? [jogador, inimigo] : [inimigo, jogador];
}

function scr_executar_acao(atacante, alvo, indice_movimento)
{
    if (indice_movimento < 0 || indice_movimento >= array_length(atacante.movimentos))
    {
        return {
            sucesso: false,
            acertou: false,
            atacante_nome: atacante.nome,
            alvo_nome: alvo.nome,
            movimento_nome: "Nenhum",
            motivo: "Ação Inválida",
            categoria: "status",
            dano: 0,
            critico: false,
            efetividade: 1,
            desmaiou: false,
            subiu_nivel: false,
            novos_movimentos: []
        };
    }

    var _mov_instancia = atacante.movimentos[indice_movimento];
    var _mov_dados = global.movimentos[$ _mov_instancia.movimento_id];
    var _nivel_antes = atacante.nivel;

    if (is_undefined(_mov_dados))
    {
        return {
            sucesso: false,
            acertou: false,
            atacante_nome: atacante.nome,
            alvo_nome: alvo.nome,
            movimento_nome: "Movimento inválido",
            motivo: "movimento_inexistente"
        };
    }

    var _resultado = scr_usar_movimento(atacante, alvo, indice_movimento);

    _resultado.atacante_nome = atacante.nome;
    _resultado.alvo_nome = alvo.nome;
    _resultado.movimento_nome = _mov_dados.nome;
    _resultado.subiu_nivel = (atacante.nivel > _nivel_antes);
    _resultado.nivel_novo = atacante.nivel;
    _resultado.xp_atual = atacante.xp;
    _resultado.xp_prox_nivel = atacante.xp_prox_nivel;

    return _resultado;
}

function scr_usar_movimento(atacante, alvo, indice_movimento)
{
    if (indice_movimento < 0 || indice_movimento >= array_length(atacante.movimentos))
    {
        return { sucesso: false, acertou: false, motivo: "acao_invalida" };
    }

    var _mov_instancia = atacante.movimentos[indice_movimento];
    var _mov_dados = global.movimentos[$ _mov_instancia.movimento_id];

    if (is_undefined(_mov_dados)) return { sucesso: false, acertou: false, motivo: "movimento_inexistente" };

    if (_mov_instancia.pp_atual <= 0) return { sucesso: false, motivo: "sem_pp" };

    if (atacante.apaixonado && random(1) < 0.5)
    {
        return { sucesso: true, acertou: false, motivo: "apaixonado" };
    }

    if (alvo.esta_desmaiado && _mov_dados.categoria != "status") return { sucesso: false, motivo: "alvo_desmaiado" };

    _mov_instancia.pp_atual -= 1;

    var _acertou = true;
    if (_mov_dados.precisao > 0)
    {
        var _precisao_final = scr_get_precisao_final(atacante, alvo, _mov_dados);
        _acertou = (random(100) <= _precisao_final);
    }
    if (!_acertou) return { sucesso: true, acertou: false, motivo: "errou" };

    if (_mov_dados.categoria == "status")
    {
        var _retorno_status = scr_aplicar_efeito_status(atacante, alvo, _mov_dados);
        _retorno_status.sucesso = true;
        _retorno_status.acertou = true;
        _retorno_status.categoria = "status";
        return _retorno_status;
    }

    if (alvo.estados_volateis.protegido)
    {
        alvo.estados_volateis.protegido = false;
        return {
            sucesso: true,
            acertou: true,
            categoria: _mov_dados.categoria,
            dano: 0,
            critico: false,
            efetividade: 0,
            desmaiou: false,
            subiu_nivel: false,
            novos_movimentos: [],
            evoluiu: false,
            evolucao_info: undefined,
            ativou_cute_charm: false,
            efeito_secundario_info: { ativou: false },
            motivo: "protegido"
        };
    }

    var _hp_alvo_antes = alvo.hp_atual;
    var _resultado = scr_calcular_dano(atacante, alvo, _mov_instancia.movimento_id);

    alvo.hp_atual -= _resultado.dano;
    alvo.hp_atual = clamp(alvo.hp_atual, 0, alvo.hp_max);
    var _dano_aplicado = _hp_alvo_antes - alvo.hp_atual;
    var _dano_percentual = (alvo.hp_max > 0)
        ? round((_dano_aplicado / alvo.hp_max) * 100)
        : 0;

    var _desmaiou = (alvo.hp_atual <= 0);

    if (_desmaiou)
    {
        alvo.esta_desmaiado = true;
        var _xp_ganho = scr_calcular_xp_ganho(alvo, atacante.nivel);
        var _res_xp = scr_ganhar_xp(atacante, _xp_ganho);
        
        return {
            sucesso: true,
            acertou: true,
            categoria: _mov_dados.categoria,
            dano: _resultado.dano,
            dano_percentual: _dano_percentual,
            critico: _resultado.critico,
            efetividade: _resultado.efetividade,
            desmaiou: true,
            subiu_nivel: _res_xp.subiu,
            novos_movimentos: _res_xp.novos_movimentos,
            evoluiu: _res_xp.evoluiu,
            evolucao_info: _res_xp.evolucao_info,
            ativou_cute_charm: false,
            efeito_secundario_info: { ativou: false }
        };
    }

    var _ativou_cute_charm = scr_aplicar_habilidade_defensor(alvo, atacante, _mov_dados);
    var _info_secundario = scr_processar_efeito_secundario(atacante, alvo, _mov_dados);

    return {
        sucesso: true,
        acertou: true,
        categoria: _mov_dados.categoria,
        dano: _resultado.dano,
        dano_percentual: _dano_percentual,
        critico: _resultado.critico,
        efetividade: _resultado.efetividade,
        desmaiou: false,
        subiu_nivel: false,
        novos_movimentos: [],
        evoluiu: false,
        evolucao_info: undefined,
        ativou_cute_charm: _ativou_cute_charm,
        efeito_secundario_info: _info_secundario
    };
}

function scr_aplicar_efeito_status(usuario, alvo, mov_dados)
{
    var _efeito = mov_dados.efeito;
    var _alvo_efeito = (_efeito.alvo == "oponente") ? alvo : usuario;

    switch (_efeito.tipo)
    {
        case "status":
            var _aplicou = scr_aplicar_status(_alvo_efeito, _efeito.status_id);
            return { tipo_efeito: "status", status_id: _efeito.status_id, aplicou: _aplicou };

        case "cura":
            var _cura = floor(usuario.hp_max * _efeito.valor);
            usuario.hp_atual = clamp(usuario.hp_atual + _cura, 0, usuario.hp_max);
            return { tipo_efeito: "cura", valor_curado: _cura };

        case "clima":
            global.campo.clima = _efeito.clima;
            return { tipo_efeito: "clima", clima: _efeito.clima };

        case "foco":
            _alvo_efeito.estados_volateis.foco = true;
            return { tipo_efeito: "foco" };

        case "protecao":
            _alvo_efeito.estados_volateis.protegido = true;
            return { tipo_efeito: "protecao" };

        case "attract":
            if (usuario.genero == "sem_genero" || alvo.genero == "sem_genero" || usuario.genero == alvo.genero)
            {
                return { tipo_efeito: "falhou" };
            }
            alvo.apaixonado = true;
            return { tipo_efeito: "attract", sucesso: true };

        case "captivate":
            if (usuario.genero != "sem_genero" && alvo.genero != "sem_genero" && usuario.genero != alvo.genero)
            {
                var _estagio_antigo = alvo.estagios.atk_esp;
                var _estagio_novo = clamp(_estagio_antigo - 2, -6, 6);
                alvo.estagios.atk_esp = _estagio_novo;

                return {
                    tipo_efeito: "debuff",
                    stat: "atk_esp",
                    estagio_novo: _estagio_novo,
                    estagios_alterados: abs(_estagio_novo - _estagio_antigo),
                    mudou: (_estagio_novo != _estagio_antigo)
                };
            }
            return { tipo_efeito: "falhou" };

        case "buff":
        case "debuff":
            if (_efeito.tipo == "debuff" && _alvo_efeito.habilidade == "big_pecks" && _efeito.stat == "def")
                return { tipo_efeito: "bloqueado", habilidade: "big_pecks" };
            var _sinal = (_efeito.tipo == "buff") ? 1 : -1;
            var _estagio_antigo = _alvo_efeito.estagios[$ _efeito.stat];
            var _estagio_novo = clamp(_estagio_antigo + (_sinal * _efeito.estagios), -6, 6);
            _alvo_efeito.estagios[$ _efeito.stat] = _estagio_novo;

            return {
                tipo_efeito: _efeito.tipo,
                stat: _efeito.stat,
                estagio_novo: _estagio_novo,
                estagios_alterados: abs(_estagio_novo - _estagio_antigo),
                mudou: (_estagio_novo != _estagio_antigo)
            };

        case "volatil":
            var _alvo_vol = (_efeito.alvo == "oponente") ? alvo : usuario;
            var _aplicou_vol = scr_aplicar_estado_volatil(usuario, _alvo_vol, _efeito.estado_id);
            return { tipo_efeito: "volatil", estado_id: _efeito.estado_id, aplicou: _aplicou_vol, alvo_nome: _alvo_vol.nome };

        case "habilidade":
            _alvo_efeito.habilidade = _efeito.habilidade;
            return { tipo_efeito: "habilidade", habilidade: _efeito.habilidade };

        case "perish_song":
            var _apl_usuario = scr_aplicar_estado_volatil(usuario, usuario, "perish_song");
            var _apl_alvo = scr_aplicar_estado_volatil(usuario, alvo, "perish_song");
            return { tipo_efeito: "perish_song", aplicou_usuario: _apl_usuario, aplicou_alvo: _apl_alvo };

        default:
            return { tipo_efeito: "nenhum" };
    }
}

function scr_tentar_captura(item_id, alvo, treinador_jogador, turno)
{
    if (!variable_struct_exists(global.itens, item_id)) return { sucesso: false, mensagem: "Item inexistente." };
    var _bola = global.itens[$ item_id];
    if (_bola.utilidade != "captura") return { sucesso: false, mensagem: "Esse item nao e uma Pokebola." };
    if (alvo.esta_desmaiado) return { sucesso: false, mensagem: "Nao e possivel capturar um Pokemon desmaiado." };
    if (!scr_mochila_remover(item_id, 1)) return { sucesso: false, mensagem: "Voce nao possui essa Pokebola." };
    var _base = global.especies[$ alvo.especie_id];
    var _taxa_base = clamp(_base.taxa_captura, 1, 255);
    var _multiplicador = variable_struct_exists(_bola, "multiplicador_captura") ? _bola.multiplicador_captura : 1;
    if (item_id == "timerball") _multiplicador = min(4, 1 + (turno / 10));
    if (item_id == "quickball" && turno <= 1) _multiplicador = 5;
    if (variable_struct_exists(_bola, "bonus_tipos"))
    {
        for (var _i = 0; _i < array_length(_bola.bonus_tipos); _i++)
        {
            if (alvo.tipo1 == _bola.bonus_tipos[_i] || alvo.tipo2 == _bola.bonus_tipos[_i])
            {
                _multiplicador = _bola.bonus_tipo_multiplicador;
                break;
            }
        }
    }
    var _hp_fator = (3 * alvo.hp_max - (2 * alvo.hp_atual)) / (3 * alvo.hp_max);
    var _status_fator = (alvo.status == "sono" || alvo.status == "congelamento") ? 2.5 : 1;
    if (_status_fator == 1 && alvo.status != "nenhum") _status_fator = 1.5;
    var _chance = clamp((_taxa_base * _multiplicador * _hp_fator * _status_fator) / 255, 0, 1);
    var _capturou = variable_struct_exists(_bola, "captura_garantida") && _bola.captura_garantida;
    if (!_capturou) _capturou = random(1) < _chance;
    if (_capturou)
    {
        if (array_length(treinador_jogador.monstros) < 6)
        {
            alvo.hp_atual = clamp(alvo.hp_atual, 1, alvo.hp_max);
            alvo.esta_desmaiado = false;
            array_push(treinador_jogador.monstros, alvo);
            var _felicidade_bonus = variable_struct_exists(_bola, "felicidade_bonus") ? _bola.felicidade_bonus : 0;
            alvo.felicidade = clamp(alvo.felicidade + _felicidade_bonus, 0, 255);
            return { sucesso: true, capturou: true, mensagem: "Voce capturou " + alvo.nome + "!" };
        }
        if (!variable_global_exists("caixa_pokemon")) global.caixa_pokemon = [];
        array_push(global.caixa_pokemon, alvo);
        return { sucesso: true, capturou: true, mensagem: alvo.nome + " foi enviado para a caixa Pokemon." };
    }
    return { sucesso: true, capturou: false, mensagem: alvo.nome + " escapou da Pokebola!" };
}
