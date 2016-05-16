--Dinomist Eruption
function c80001102.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DELAYED_QUICKEFFECT)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c80001102.condition)
	e1:SetTarget(c80001102.target)
	e1:SetOperation(c80001102.operation)
	c:RegisterEffect(e1)
end

function c80001102.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and	c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsSetCard(0xd8)
end
function c80001102.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c80001102.cfilter,1,nil,tp)
end
function c80001102.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c80001102.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
