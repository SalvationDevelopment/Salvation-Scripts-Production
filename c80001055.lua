--Digital Bug - Corebage
function c80001055.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c80001055.ovfilter1,5,2,nil,nil,5)
	c:EnableReviveLimit()
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80001055,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c80001055.xyzcon)
	e1:SetOperation(c80001055.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(c80001055.cost)
	e2:SetTarget(c80001055.tdtg)
	e2:SetOperation(c80001055.tdop)
	c:RegisterEffect(e2)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80001055,1))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c80001055.mattg)
	e3:SetOperation(c80001055.matop)
	c:RegisterEffect(e3)
end

function c80001055.ovfilter1(c)
	return c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c80001055.ovfilter2(c,tp,xyzc)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsType(TYPE_XYZ) and c:IsCanBeXyzMaterial(xyzc)
		and (c:GetRank()==3 or c:GetRank()==4) and c:CheckRemoveOverlayCard(tp,2,REASON_COST)
end
function c80001055.xyzcon(e,c,tp)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c80001055.ovfilter2,c:GetControler(),LOCATION_MZONE,0,1,nil,tp,c)
end
function c80001055.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mg=Duel.SelectMatchingCard(tp,c80001055.ovfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	mg:GetFirst():RemoveOverlayCard(tp,2,2,REASON_COST)
	local mg2=mg:GetFirst():GetOverlayGroup()
	if mg2:GetCount()~=0 then
		Duel.Overlay(c,mg2)
	end
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
end

function c80001055.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80001055.tdfilter(c)
	return c:IsPosition(POS_DEFENCE) and c:IsAbleToDeck()
end
function c80001055.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c80001055.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80001055.tdfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c80001055.tdfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c80001055.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end

function c80001055.cfilter(c)
	local np=c:GetPosition()
	local pp=c:GetPreviousPosition()
	return (pp==0x1 and np==0x4) or (pp==0x4 and np==0x1) or (pp==0x8 and np==0x1)
end
function c80001055.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return eg:IsContains(chkc) and c80001055.cfilter(chkc) end
	if chk==0 then return eg:IsExists(c80001055.cfilter,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,0,1,nil,RACE_INSECT) end
end
function c80001055.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,0,1,nil,RACE_INSECT) or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,Card.IsRace,tp,LOCATION_GRAVE,0,1,1,nil,RACE_INSECT)
	Duel.Overlay(c,g)
end