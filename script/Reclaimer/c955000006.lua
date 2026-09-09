Duel.LoadScript("MeubleConstant.lua")

--Infested Sanghel "Elites"
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    Fusion.AddProcMixN(c,true,true,955000010,1,aux.FilterBoolFunctionEx(Card.IsRace,RACE_GALAXY),1)
end