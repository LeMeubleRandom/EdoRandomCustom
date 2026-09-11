Duel.LoadScript("MeubleConstant.lua")

--Recruits in Plague
local s,id=GetID()
function s.initial_effect(c)
	local params = {fusfilter=aux.FilterBoolFunction(Card.ListsCodeAsMaterial,CARD_INFESTED_RECRUITS),matfilter=Fusion.OnFieldMat(Card.IsAbleToDeck),extrafil=s.fextra,extraop=Fusion.ShuffleMaterial,extratg=s.extratg}
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_ATTACK,TIMINGS_CHECK_MONSTER_E|TIMING_ATTACK)
	e1:SetCondition(s.fuscon)
	e1:SetOperation(s.fusac(Fusion.SummonEffTG(table.unpack(params)),Fusion.SummonEffOP(table.unpack(params))))
	c:RegisterEffect(e1)
end
s.listed_names={CARD_INFESTED_RECRUITS}
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsFaceup,Card.IsAbleToDeck),tp,LOCATION_GRAVE,0,nil)
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_MZONE|LOCATION_GRAVE|LOCATION_REMOVED)
end
function s.fuscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,CARD_INFESTED_RECRUITS),tp,LOCATION_MZONE,0,1,nil)
end
function s.fustg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    
end
function s.fusac(fustg,fusop)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if not tc:IsRelateToEffect(e) then return end
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and fustg(e,tp,eg,ep,ev,re,r,rp,0)
			and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			fusop(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end