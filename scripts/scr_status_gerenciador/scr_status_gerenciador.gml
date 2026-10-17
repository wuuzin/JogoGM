function scr_aplicar_status(alvo, status_id)
{
    if (alvo.status != "nenhum") return false; // Pokémon já possui status majoritário

    // Imunidades por terreno
    if (global.campo.terreno == "eletrico" && status_id == "sono") return false;
    if (global.campo.terreno == "nebuloso") return false;

    // Imunidades elementares nativas
    if (status_id == "queimadura" && (alvo.tipo1 == "fogo" || alvo.tipo2 == "fogo")) return false;
    if (status_id == "paralisia" && (alvo.tipo1 == "eletrico" || alvo.tipo2 == "eletrico")) return false;
    if ((status_id == "envenenamento" || status_id == "intoxicacao") && 
        (alvo.tipo1 == "veneno" || alvo.tipo2 == "veneno" || alvo.tipo1 == "metal" || alvo.tipo2 == "metal")) return false;
    if (status_id == "congelamento" && (alvo.tipo1 == "gelo" || alvo.tipo2 == "gelo")) return false;

    alvo.status = status_id;
    alvo.turnos_status = 1;
    
    if (status_id == "sono") alvo.turnos_status = irandom_range(1, 3);

    return true;
}

function scr_pode_atacar_status(monstro)
{
    if (monstro.esta_desmaiado)
    {
        return { pode: false, motivo: monstro.nome + " está desmaiado!" };
    }

    if (monstro.status == "paralisia")
    {
        if (random(100) < 25) return { pode: false, motivo: "Paralisado! Não conseguiu se mover!" };
    }
    else if (monstro.status == "sono")
    {
        monstro.turnos_status--;
        if (monstro.turnos_status <= 0)
        {
            monstro.status = "nenhum";
            return { pode: true, motivo: monstro.nome + " acordou!" };
        }
        return { pode: false, motivo: monstro.nome + " está dormindo profundamente..." };
    }
    else if (monstro.status == "congelamento")
    {
        if (random(100) < 20)
        {
            monstro.status = "nenhum";
            return { pode: true, motivo: monstro.nome + " descongelou!" };
        }
        return { pode: false, motivo: monstro.nome + " está congelado!" };
    }

    return { pode: true, motivo: "" };
}

function scr_processar_dano_status_fim_turno(monstro)
{
    if (monstro.esta_desmaiado || monstro.status == "nenhum") return "";

    var _dano = 0;
    var _msg = "";

    switch (monstro.status)
    {
        case "queimadura":
            _dano = max(1, floor(monstro.hp_max / 16));
            _msg = monstro.nome + " sofreu dano da queimadura!";
            break;

        case "envenenamento":
            _dano = max(1, floor(monstro.hp_max / 8));
            _msg = monstro.nome + " sofreu dano do veneno!";
            break;

        case "intoxicacao":
            _dano = max(1, floor((monstro.hp_max / 16) * monstro.turnos_status));
            monstro.turnos_status++;
            _msg = monstro.nome + " sofreu dano severo da intoxicação!";
            break;
    }

    if (_dano > 0)
    {
        monstro.hp_atual = max(0, monstro.hp_atual - _dano);
        if (monstro.hp_atual == 0) monstro.esta_desmaiado = true;
    }

    return _msg;
}

function scr_get_spd_com_status(monstro)
{
    var _spd = scr_get_stat_efetivo(monstro, "spd");
    if (monstro.status == "paralisia") _spd = floor(_spd * 0.5);
    return _spd;
}

function scr_aplicar_estado_volatil(usuario, alvo, estado_id)
{
    switch (estado_id)
    {
        case "confuso":
            if (alvo.estados_volateis.confuso.ativo) return false;
            if (global.campo.terreno == "nebuloso") return false; // Terreno Nebuloso protege da confusão

            alvo.estados_volateis.confuso.ativo = true;
            alvo.estados_volateis.confuso.turnos = irandom_range(2, 5);
            return true;

        case "hesitacao":
            alvo.estados_volateis.hesitacao = true;
            return true;

        case "preso":
            if (alvo.estados_volateis.preso.ativo) return false;
            alvo.estados_volateis.preso.ativo = true;
            alvo.estados_volateis.preso.turnos = irandom_range(4, 5);
            return true;

        case "leech_seed":
            if (alvo.tipo1 == "planta" || alvo.tipo2 == "planta") return false; // tipo Planta é imune
            if (alvo.estados_volateis.leech_seed) return false;

            alvo.estados_volateis.leech_seed = true;
            alvo.estados_volateis.leech_seed_de = usuario;
            return true;

        case "perish_song":
            if (alvo.estados_volateis.perish_song.ativo) return false;
            alvo.estados_volateis.perish_song.ativo = true;
            alvo.estados_volateis.perish_song.turnos = 3;
            return true;
    }

    return false;
}

function scr_pode_atacar_volatil(monstro)
{
    if (monstro.estados_volateis.hesitacao)
    {
        monstro.estados_volateis.hesitacao = false;
        return { pode: false, motivo: monstro.nome + " hesitou e não conseguiu se mover!" };
    }

    if (monstro.estados_volateis.confuso.ativo)
    {
        monstro.estados_volateis.confuso.turnos -= 1;

        if (monstro.estados_volateis.confuso.turnos <= 0)
        {
            monstro.estados_volateis.confuso.ativo = false;
        }
        else if (random(100) < 33)
        {
            var _dano_confusao = max(1, floor(monstro.hp_max / 8));
            monstro.hp_atual = max(0, monstro.hp_atual - _dano_confusao);
            if (monstro.hp_atual <= 0) monstro.esta_desmaiado = true;

            return { pode: false, motivo: monstro.nome + " está confuso e se machucou! (" + string(_dano_confusao) + " de dano)" };
        }
    }

    return { pode: true, motivo: "" };
}

function scr_processar_estados_volateis_fim_turno(monstro)
{
    var _msgs = [];
    if (monstro.esta_desmaiado) return _msgs;

    if (monstro.habilidade == "rain_dish" && variable_struct_exists(global.campo, "clima") && global.campo.clima == "chuva")
    {
        var _cura_chuva = max(1, floor(monstro.hp_max / 16));
        monstro.hp_atual = min(monstro.hp_max, monstro.hp_atual + _cura_chuva);
        array_push(_msgs, monstro.nome + " recuperou HP com Rain Dish!");
    }

    if (monstro.habilidade == "shed_skin" && monstro.status != "nenhum" && random(100) < 33)
    {
        monstro.status = "nenhum";
        monstro.turnos_status = 0;
        array_push(_msgs, monstro.nome + " trocou de pele e se livrou do status!");
    }

    if (monstro.estados_volateis.leech_seed)
    {
        var _dreno = max(1, floor(monstro.hp_max / 8));
        monstro.hp_atual = max(0, monstro.hp_atual - _dreno);
        if (monstro.hp_atual <= 0) monstro.esta_desmaiado = true;

        array_push(_msgs, monstro.nome + " teve HP drenado pelo Leech Seed!");

        var _receptor = monstro.estados_volateis.leech_seed_de;
        if (_receptor != undefined && !_receptor.esta_desmaiado)
        {
            _receptor.hp_atual = min(_receptor.hp_max, _receptor.hp_atual + _dreno);
            array_push(_msgs, _receptor.nome + " recuperou HP através do Leech Seed!");
        }
    }

    if (monstro.estados_volateis.perish_song.ativo)
    {
        monstro.estados_volateis.perish_song.turnos -= 1;
        array_push(_msgs, monstro.nome + " tem " + string(monstro.estados_volateis.perish_song.turnos) + " turno(s) de Perish Song restantes!");

        if (monstro.estados_volateis.perish_song.turnos <= 0)
        {
            monstro.hp_atual = 0;
            monstro.esta_desmaiado = true;
            array_push(_msgs, monstro.nome + " desmaiou por causa de Perish Song!");
        }
    }

    if (monstro.estados_volateis.preso.ativo)
    {
        monstro.estados_volateis.preso.turnos -= 1;
        if (monstro.estados_volateis.preso.turnos <= 0)
        {
            monstro.estados_volateis.preso.ativo = false;
            array_push(_msgs, monstro.nome + " não está mais preso!");
        }
    }

    return _msgs;
}
