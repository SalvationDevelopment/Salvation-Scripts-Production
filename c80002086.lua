--デーモン・イーター
function c80002086.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,80002086)
	e1:SetTarget(c80002086.target)
	e1:SetOperation(c80002086.operation)
	c:RegisterEffect(e1)
end
function c80002086.filter(c)
	return c:IsSetCard(0xd2) and c:IsDestructable()
end
function c80002086.rmfilter(c)
	return c:IsAbleToRemove()
end
function c80002086.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c80002086.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80002086.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c80002086.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c80002086.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c80002086.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
