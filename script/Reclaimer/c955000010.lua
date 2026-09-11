Duel.LoadScript("MeubleConstant.lua")

--Infested Recruits
local s,id=GetID()
function s.initial_effect(c)
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE|EFFECT_FLAG_SINGLE_RANGE)
    e0:SetRange(LOCATION_ALL)
    e0:SetCode(EFFECT_ADD_RACE)
	e0:SetValue(RACE_WARRIOR|RACE_GALAXY)
	c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_FUSION_SUMMON|CATEGORY_TOGRAVE)
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
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY,EFFECT_FLAG2_CHECK_SIMULTANEOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,{id,2})
    e2:SetCondition(s.spcon)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsType(TYPE_LINK) and c:IsFaceup()
end
function s.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local params={fusfilter=function(c) return c:IsSetCard(SET_INFESTED) end}
        return Fusion.SummonEffTG(params)(e,tp,eg,ep,ev,re,r,rp,0) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
    local params={fusfilter=function(c) return c:IsSetCard(SET_INFESTED) end}
    Fusion.SummonEffTG(params)(e,tp,eg,ep,ev,re,r,rp,1) 
end
function s.fusop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,nil)
    if #sg==0 then return end
	if Duel.SendtoGrave(sg,REASON_EFFECT)>0 then
        local fusion_params={
            fusfilter=function(c) return c:IsSetCard(SET_INFESTED) end
        }
		Fusion.SummonEffOP(fusion_params)(e,tp,eg,ep,ev,re,r,rp)
    end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	return eg:IsExists(s.cfilter,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false)) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,tp,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,c,1,tp,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	aux.ToHandOrElse(c,tp,
		function(sc) return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false) end,
		function(sc) Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) end,
		aux.Stringid(id,1)
	)
end