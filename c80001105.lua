--Friendly Fire
function c80001105.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c80001105.negcon)
	e1:SetTarget(c80001105.target)
	e1:SetOperation(c80001105.activate)
	c:RegisterEffect(e1)
end

function c80001105.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c80001105.filter(c,e)
	return c:IsDestructable() and c~=e:GetHandler()
end
function c80001105.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c80001105.filter(chkc,e) end
	if chk==0 then return Duel.IsExistingTarget(c80001105.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,eg:GetFirst(),e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c80001105.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,eg:GetFirst(),e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c80001105.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end