Duel.LoadScript("MeubleConstant.lua")

--The Gravemind
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    Fusion.AddProcMixN(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,SET_RECRUIT),s.ffilter,1,99,s.gfilter,1,99)
    c:AddMustBeFusionSummoned()
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
    e0:SetRange(LOCATION_ALL)
    e0:SetCode(EFFECT_ADD_RACE)
	e0:SetValue(RACE_WARRIOR+RACE_GALAXY)
	c:RegisterEffect(e0)
    local e0a=Effect.CreateEffect(c)
	e0a:SetDescription(aux.Stringid(id,0))
	e0a:SetType(EFFECT_TYPE_FIELD)
	e0a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0a:SetCode(EFFECT_SPSUMMON_PROC)
	e0a:SetRange(LOCATION_EXTRA)
	e0a:SetCondition(s.selfspcon)
	e0a:SetTarget(s.selfsptg)
	e0a:SetOperation(s.selfspop)
	e0a:SetValue(1)
	c:RegisterEffect(e0a)
    local e0b=Effect.CreateEffect(c)
	e0b:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0b:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0b:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0b:SetCondition(s.regcon)
	e0b:SetOperation(s.regop)
	c:RegisterEffect(e0b)
end
function s.gfilter(c,fc,sumtype,tp)
	return c:IsLocation(LOCATION_GRAVE)
end
function s.ffilter(c)
	return c:IsLocation(LOCATION_MZONE)
end
function s.selfspcostfilter(c,tp,fc)
	c:IsCanBeFusionMaterial(fc,MATERIAL_FUSION) and (c:IsControler(tp) or c:IsFaceup())
end
function s.rescon(sg,e,tp,mg)
	return Duel.GetLocationCountFromEx(tp,tp,sg,e:GetHandler())>0
		and sg:FilterCount(Card.IsControler,nil,tp)==1
        and sg:IsExists(Card.IsCode,nil,995000010)
end
function s.selfspcon(e,c)
	if not c then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(s.selfspcostfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp,c)
	return #mg>=2 and aux.SelectUnselectGroup(mg,e,tp,2,2,s.rescon,0)
end
function s.selfsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(s.selfspcostfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp,c)
	local g=aux.SelectUnselectGroup(mg,e,tp,2,2,s.rescon,1,tp,HINTMSG_RELEASE,nil,nil,true)
	if #g>0 then
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.selfspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST|REASON_MATERIAL)
end
function s.regcon(e)
	local c=e:GetHandler()
	return c:IsFusionSummoned() or c:IsSummonType(SUMMON_TYPE_SPECIAL+1)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c,sump,sumtype) return c:IsOriginalCodeRule(id) and (sumtype&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION or sumtype&SUMMON_TYPE_SPECIAL+1==SUMMON_TYPE_SPECIAL+1) end)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end