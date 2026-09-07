Duel.LoadScript("MeubleConstant.lua")

--"I Need A Weapon"
local s,id=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.acttg)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.efftg)
	e2:SetOperation(s.effop)
	c:RegisterEffect(e2)
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if s.sptg(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		s.sptg(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(s.spop)
	else
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,Card.IsCanBeSpecialSummoned,tp,LOCATION_GRAVE,0,1,1,nil,e,0,tp,false,false)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,LOCATION_GRAVE,0,1,nil,e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.stfilter(c)
	return c:IsSetCard(SET_RECRUIT) and c:IsTrap() and c:IsSSetable()
end
function s.tdfilter(sg,e,tp,mg)
	return sg:IsExists(Card.IsSetCard,1,nil,SET_RECRUIT)
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(s.stfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil)
		local b2=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE,0,nil)
		return b1 or b2 and #b2>=3 and b2:IsExists(Card.IsSetCard,1,nil,SET_RECRUIT) and Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_SET,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_GRAVE)
    Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(s.stfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil)
	local b2=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE,0,3,nil,e,tp)
	local link_chk=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,CARD_THE_CHOSEN_ONE,CARD_THE_FALLEN_ONE)
	local op=nil
	if not link_chk then
		op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(id,2)},
			{b2,aux.Stringid(id,3)})
	end
	local breakeffect=false
	if (op and op==1) or (link_chk and b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(id,2)))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,s.stfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SSet(tp,g)
		end
		breakeffect=true
	end
	if (op and op==2) or (link_chk and b2 and (not breakeffect or Duel.SelectYesNo(tp,aux.Stringid(id,3)))) then
	    local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE,0,nil)
        if #g<3 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local sg=g:SelectSubGroup(tp,s.tdfilter,false,3,3)
        if sg then
	        Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
        end
	end
end