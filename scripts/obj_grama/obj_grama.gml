// Compatibilidade retroativa: a implementacao real reside em scr_grama.gml
function obj_grama_iniciar()
{
    scr_grama_passo_iniciar();
}

function obj_grama_verificar_passo()
{
    return scr_grama_verificar_passo();
}

function obj_grama_rearmar()
{
    scr_grama_rearmar();
}