--波紋のバリア －ウェーブ・フォース－ - Rippling Mirror Force
function c80001075.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c80001075.condition)
	e1:SetTarget(c80001075.target)
	e1:SetOperation(c80001075.activate)
	c:RegisterEffect(e1)
end
function c80001075.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetAttackTarget()==nil
end
function c80001075.filter(c)
	return c:IsAttackPos() and c:IsAbleToDeck()
end
function c80001075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80001075.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c80001075.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c80001075.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80001075.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(1-tp)
	end
end
