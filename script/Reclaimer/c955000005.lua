Duel.LoadScript("MeubleConstant.lua")

--Elites Soldiers
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTunerEx(Card.IsSetCard,SET_RECRUIT),1,99)
end