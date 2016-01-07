--Drifting Spirit of Winter Blossoms
--By: HelixReactor
function c62015408.initial_effect(c)
	--Remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,62015408)
	e1:SetCondition(c62015408.condition)
	e1:SetCost(c62015408.cost)
	e1:SetOperation(c62015408.operation)
	c:RegisterEffect(e1)
end
function c62015408.condition(e,tp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0
end
function c62015408.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c62015408.filter(c,code)
	return c:IsCode(code) and c:IsAbleToRemove()
end
function c62015408.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		local tg=g:GetFirst()
		Duel.ConfirmCards(1-tp,tg)
		local ge=Duel.GetMatchingGroup(nil,tp,0,LOCATION_EXTRA,nil)
		if ge:GetCount()>0 then
			Duel.ConfirmCards(tp,ge)
			local gr=Duel.GetMatchingGroup(c62015408.filter,tp,0,LOCATION_EXTRA,nil,tg:GetCode())
			if gr:GetCount()>0 then Duel.Remove(gr,POS_FACEUP,REASON_EFFECT) end
		end
	end
end