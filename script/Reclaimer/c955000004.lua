Duel.LoadScript("MeubleConstant.lua")

--Earth recruits
local s,id=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,{id,1})
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
end
function s.thfilter(c)
	return c:IsMonster() and c:IsSetCard(SET_RECRUIT) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned())
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil,e,tp,Duel.GetLocationCount(tp,LOCATION_MZONE)>0) end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local mzone_chk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,4))
	local sc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,e,tp,mzone_chk):GetFirst()
	aux.ToHandOrElse(sc,tp,
		function()
			return mzone_chk and sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		end,
		function()
			if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
                local e2=Effect.CreateEffect(c)
                e2:SetType(EFFECT_TYPE_SINGLE)
                e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                e2:SetCode(EFFECT_CHANGE_LEVEL)
                e2:SetValue(4)
                e2:SetReset(RESET_EVENT|RESETS_STANDARD)
                e2:SetDescription(aux.Stringid(id,0))
                sc:RegisterEffect(e2)
            end
		end,
        aux.Stringid(id,4),
        Duel.SpecialSummonComplete()
	)
	local c=e:GetHandler()
end