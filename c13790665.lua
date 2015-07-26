--Painful Decision
function c13790665.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,13790665+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c13790665.target)
	e1:SetOperation(c13790665.activate)
	c:RegisterEffect(e1)
end
function c13790665.filter(c,tp)
	return c:IsLevelBelow(4) and c:IsType(TYPE_NORMAL) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c13790665.filter2,tp,LOCATION_DECK,0,1,c,c:GetCode())
end
function c13790665.filter2(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c13790665.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c13790665.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c13790665.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c13790665.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g1:GetCount()>0 then
		local tg1=g1:GetFirst()
		Duel.SendtoGrave(tg1,REASON_EFFECT)
		local g2=Duel.SelectMatchingCard(tp,c13790665.filter2,tp,LOCATION_DECK,0,1,1,tg1,tg1:GetCode())
		if g2:GetCount()>0 then
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end
