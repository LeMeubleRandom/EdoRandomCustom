Duel.LoadScript("MeubleConstant.lua")

--Infested Recruits
local s,id=GetID()
function s.initial_effect(c)
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
    e0:SetRange(LOCATION_ALL)
    e0:SetCode(EFFECT_ADD_RACE)
	e0:SetValue(RACE_WARRIOR+RACE_GALAXY)
	c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_MAIN_END|TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,{id,1})
	e1:SetCondition(function() return Duel.IsMainPhase() end)
    e1:SetCost(Cost.SelfReveal)	
    e1:SetTarget(s.fustg)
	e1:SetOperation(s.fusop)
	c:RegisterEffect(e1)
end
function s.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local params={fusfilter=aux.FilterBoolFunction(Card.IsSetCard,SET_INFESTED)}
		return Fusion.SummonEffTG(params)(e,tp,eg,ep,ev,re,r,rp,0) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
	end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Fusion.SummonEffTG({fusfilter=aux.FilterBoolFunction(Card.IsSetCard,SET_INFESTED)})(e,tp,eg,ep,ev,re,r,rp,1)
end
function s.fusop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,nil)
    if #sg==0 then return end
	if Duel.SendtoGrave(sg,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
        local fusion_params={
            fusfilter=function(c) return c:IsSetCard(SET_INFESTED) end
        }
        Fusion.SummonEffTG(fusion_params)(e,tp,eg,ep,ev,re,r,rp,1)
    end
end