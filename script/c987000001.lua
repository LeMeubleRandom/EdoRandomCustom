--Hieratic Dragon of Seth
local s,id=GetID()
function s.initial_effect(c)
    --Special Summon Procedure
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(id,0))
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_HAND)
    e0:SetCountLimit(1,{id,0},EFFECT_COUNT_CODE_OATH)
	e0:SetCode(EFFECT_SPSUMMON_PROC)

	e0:SetCondition(s.hspcon)
	e0:SetTarget(s.hsptg)
	e0:SetOperation(s.hspop)

	c:RegisterEffect(e0)
end
s.listed_series={SET_HIERATIC}

function s.searchfilter(c)
	return c:IsSetCard(SET_HIERATIC)
end

function s.hspcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local rg=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_HAND,LOCATION_MZONE,c,tp)
    return #rg>0 and aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),0)
end

function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
    local rg=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_HAND|LOCATION_MZONE,0,c,tp)
    local g=aux.SelectUnselectGroup(rg,e,tp,1,1,nil,1,tp,HINTMSG_RELEASE,nil,nil,true)
    if g and #g>0 then
		e:SetLabelObject(g)
		return true
	end
	return false
end

function s.hspop(e,tp,eg,ep,ev,re,r,rp,chk,c)
    local sg=e:GetLabelObject()
	if sg and #sg>0 then
		Duel.Release(sg,REASON_COST)
	end
end