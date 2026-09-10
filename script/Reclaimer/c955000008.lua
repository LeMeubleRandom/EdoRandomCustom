Duel.LoadScript("MeubleConstant.lua")

--Space Recruits
local s,id=GetID()
function s.initial_effect(c)
    local e1a=Effect.CreateEffect(c)
	e1a:SetDescription(aux.Stringid(id,0))
	e1a:SetCategory(CATEGORY_SET)
	e1a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1a:SetProperty(EFFECT_FLAG_DELAY)
	e1a:SetCode(EVENT_SUMMON_SUCCESS)
	e1a:SetCountLimit(1,{id,0})
	e1a:SetTarget(s.settg)
	e1a:SetOperation(s.setop)
	c:RegisterEffect(e1a)
	local e1b=e1a:Clone()
	e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1b)
end
function s.setfilter(c)
	return c:IsSetCard(SET_RECRUIT) and c:IsSpellTrap() and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SET,nil,1,tp,LOCATION_HAND|LOCATION_DECK)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,1,nil):GetFirst()
	Duel.SSet(tp,sc)
end