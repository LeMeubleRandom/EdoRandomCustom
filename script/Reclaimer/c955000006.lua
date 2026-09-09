Duel.LoadScript("MeubleConstant.lua")

--Infested Sanghel "Elites"
function s.initial_effect(c)
    c:EnableReviveLimit()
    Fusion.AddProcMixN(c,true,true,955000010,aux.FilterBoolFunctionEx(Card.IsRace,RACE_GALAXY))
end