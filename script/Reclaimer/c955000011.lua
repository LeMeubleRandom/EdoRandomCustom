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
	e1:SetCondition(s.fuscon)
	e1:SetTarget(s.fustg)
    e1:SetOperation(s.fusop)
	c:RegisterEffect(e1)
end
s.listed_names={CARD_INFESTED_RECRUITS}
function s.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsControler,nil,1-tp)<=1
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE,LOCATION_MZONE|LOCATION_GRAVE,nil),s.fcheck
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