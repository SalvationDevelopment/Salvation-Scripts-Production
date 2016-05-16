--Speedroid Pachingo-Kart
function c80001007.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80001007,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCost(c80001007.descost)
	e1:SetTarget(c80001007.destg)
	e1:SetOperation(c80001007.desop)
	c:RegisterEffect(e1)
end

function c80001007.cfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c80001007.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80001007.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c80001007.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c80001007.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c80001007.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end