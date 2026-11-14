Duel.LoadScript("MeubleConstant.lua")

--Recruits in Plague
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_ATTACK,TIMINGS_CHECK_MONSTER_E|TIMING_ATTACK)
	e1:SetCountLimit(1,{id,1})
	e1:SetCondition(s.fuscon)
	e1:SetTarget(s.fustg)
    e1:SetOperation(s.fusop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,{id,2})
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
    e2:SetHintTiming(0,TIMING_MAIN_END|TIMINGS_CHECK_MONSTER_E|TIMING_BATTLE_START|TIMING_ATTACK|TIMING_BATTLE_END)
	c:RegisterEffect(e2)
end
s.listed_names={CARD_INFESTED_RECRUITS}
function s.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsControler,nil,1-tp)<=1
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(s.fextramat,tp,LOCATION_GRAVE,LOCATION_MZONE|LOCATION_GRAVE,nil,tp),s.fcheck
end
function s.fextramat(c,tp)
	return (c:IsLocation(LOCATION_GRAVE) and c:IsMonster() or (c:IsLocation(LOCATION_MZONE) and c:IsFaceup())) 
		and c:IsAbleToDeck()
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_MZONE|LOCATION_GRAVE)
end
function s.fuscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,CARD_INFESTED_RECRUITS),tp,LOCATION_MZONE,0,1,nil)
end
function s.fustg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
	local params = {fusfilter=aux.FilterBoolFunction(Card.ListsCode,CARD_INFESTED_RECRUITS),matfilter=Fusion.OnFieldMat(Card.IsAbleToDeck),extrafil=s.fextra,extraop=Fusion.ShuffleMaterial,extratg=s.extratg}
    	return Fusion.SummonEffTG(params)(e,tp,eg,ep,ev,re,r,rp,0)
    end
	local params = {fusfilter=aux.FilterBoolFunction(Card.ListsCode,CARD_INFESTED_RECRUITS),matfilter=Fusion.OnFieldMat(Card.IsAbleToDeck),extrafil=s.fextra,extraop=Fusion.ShuffleMaterial,extratg=s.extratg}
    Fusion.SummonEffTG(params)(e,tp,eg,ep,ev,re,r,rp,1) 
end
function s.fusop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local params = {fusfilter=aux.FilterBoolFunction(Card.ListsCode,CARD_INFESTED_RECRUITS),matfilter=Fusion.OnFieldMat(Card.IsAbleToDeck),extrafil=s.fextra,extraop=Fusion.ShuffleMaterial,extratg=s.extratg}
	Fusion.SummonEffOP(params)(e,tp,eg,ep,ev,re,r,rp)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(c:IsLink(1) and c:IsAttack(2000)),tp,LOCATION_MZONE,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
            local e1=Effect.CreateEffect(c)
            e1:SetDescription(3300)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
            e1:SetReset(RESET_EVENT|RESETS_REDIRECT)
            e1:SetValue(LOCATION_REMOVED)
            c:RegisterEffect(e1,true)

			if Duel.IsExistingMatchingCard(s.syncfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.GetMatchingGroup(s.syncfilter,tp,LOCATION_EXTRA,0,nil,c)
				if #g>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sg=g:Select(tp,1,1,nil)
					Duel.SynchroSummon(tp,sg:GetFirst(),c)
				end
			end
        end
	end
end