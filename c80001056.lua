--Digital Bug Rhinocebus
function c80001056.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c80001056.ovfilter1,7,2,nil,nil,5)
	c:EnableReviveLimit()
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80001056,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c80001056.xyzcon)
	e1:SetOperation(c80001056.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80001056,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c80001056.descost)
	e3:SetTarget(c80001056.destg)
	e3:SetOperation(c80001056.desop)
	c:RegisterEffect(e3)
end

function c80001056.ovfilter1(c)
	return c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c80001056.ovfilter2(c,tp,xyzc)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsType(TYPE_XYZ) and c:IsCanBeXyzMaterial(xyzc)
		and (c:GetRank()==5 or c:GetRank()==6) and c:CheckRemoveOverlayCard(tp,2,REASON_COST)
end
function c80001056.xyzcon(e,c,tp)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c80001056.ovfilter2,c:GetControler(),LOCATION_MZONE,0,1,nil,tp,c)
end
function c80001056.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mg=Duel.SelectMatchingCard(tp,c80001056.ovfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	mg:GetFirst():RemoveOverlayCard(tp,2,2,REASON_COST)
	local mg2=mg:GetFirst():GetOverlayGroup()
	if mg2:GetCount()~=0 then
		Duel.Overlay(c,mg2)
	end
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
end

function c80001056.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80001056.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetDefence)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,tg:GetCount(),0,0)
	end
end
function c80001056.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetDefence)
		Duel.Destroy(tg,REASON_EFFECT)
	end
end