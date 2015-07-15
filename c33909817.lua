--Sylvan Princessprite
function c33909817.initial_effect(c)
--xyz summon
	aux.AddXyzProcedure(c,nil,1,2)
	c:EnableReviveLimit()
	--excavate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33909817,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,33909817)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c33909817.cost)
	e1:SetTarget(c33909817.target)
	e1:SetOperation(c33909817.operation)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33909817,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,33919817)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c33909817.cost2)
	e2:SetTarget(c33909817.target2)
	e2:SetOperation(c33909817.operation2)
	c:RegisterEffect(e2)
end
function c33909817.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33909817.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c33909817.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:GetType()==TYPE_SPELL or tc:GetType()==TYPE_TRAP then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(g,REASON_EFFECT)
	else
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c33909817.cfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsAbleToGraveAsCost()
end
function c33909817.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33909817.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c33909817.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c33909817.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x90)
end
function c33909817.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c33909817.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c33909817.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c33909817.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c33909817.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
