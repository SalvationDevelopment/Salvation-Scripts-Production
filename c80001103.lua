--揺るがぬ絆 - Unwavering Bonds
function c80001103.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c80001103.condition)
	e1:SetTarget(c80001103.target)
	e1:SetOperation(c80001103.activate)
	c:RegisterEffect(e1)
end
function c80001103.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_PENDULUM) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c80001103.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c80001103.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
