--Fluffal Wing
function c72413000.initial_effect(c)
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72413000,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c72413000.drcon)
	e1:SetCost(c72413000.drcost)
	e1:SetTarget(c72413000.drtg)
	e1:SetOperation(c72413000.drop)
	c:RegisterEffect(e1)
end

function c72413000.cfilter(c)
	return c:IsFaceup() and c:IsCode(70245411)
end
function c72413000.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c72413000.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c72413000.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c72413000.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa9) and c:IsAbleToRemoveAsCost()
end
function c72413000.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c72413000.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c72413000.rmfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsPlayerCanDraw(tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c72413000.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c72413000.tgfilter(c)
	return c:IsFaceup() and c:IsCode(70245411) and c:IsAbleToGrave()
end
function c72413000.drop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		if Duel.IsExistingMatchingCard(c72413000.tgfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(72413000,1)) then
			local g=Duel.GetMatchingGroup(c72413000.tgfilter,tp,LOCATION_ONFIELD,0,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g:Select(tp,1,1,nil)
			if Duel.SendtoGrave(sg,REASON_EFFECT)>0 then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end