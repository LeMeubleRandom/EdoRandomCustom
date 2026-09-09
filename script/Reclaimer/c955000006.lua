Duel.LoadScript("MeubleConstant.lua")

--Infested Sanghel "Elites"
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    Fusion.AddProcMixN(c,true,true,955000010,1,aux.FilterBoolFunctionEx(Card.IsRace,RACE_GALAXY),1)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,{id,1})
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
    e1:SetHintTiming(0,TIMING_STANDBY_PHASE|TIMING_MAIN_END|TIMINGS_CHECK_MONSTER_E)
	c:RegisterEffect(e1)
end
function s.disfilter(c,tp,chk)
	return c:IsNegatableMonster() and c:IsType(TYPE_EFFECT) and c:IsAbleToChangeControler()
        and (chk==1 or Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.disfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(s.disfilter,tp,0,LOCATION_MZONE,1,c,tp,chk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
	local g=Duel.SelectTarget(tp,s.disfilter,tp,0,LOCATION_MZONE,1,1,c,tp,chk)
    Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,1-tp,LOCATION_MZONE)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		--Negate its effects
        if tc:NegateEffects(e:GetHandler(),nil,true) then
            Duel.GetControl(tc,tp,RESET_PHASE|PHASE_END,1)
        end
	end
end