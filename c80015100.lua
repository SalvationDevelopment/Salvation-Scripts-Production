--輝神鳥ヴェーヌ - Radiant Divine Bird Vene
function c80015100.initial_effect(c)
	c:EnableReviveLimit()
    --change level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80015100,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c80015100.lvtg)
	e1:SetOperation(c80015100.lvop)
	c:RegisterEffect(e1)
	--To Hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_RELEASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c80015100.thcon)
	e2:SetTarget(c80015100.thtg)
	e2:SetOperation(c80015100.thop)
	c:RegisterEffect(e2)
end
function c80015100.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic()
		and Duel.IsExistingTarget(c80015100.scfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function c80015100.scfilter(c,tg)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
        and c:GetLevel()>0 and c:GetLevel()~=tg:GetLevel()
end
function c80015100.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c80015100.scfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c80015100.cfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c80015100.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,cg)
	Duel.ShuffleHand(tp)
	e:SetLabel(cg:GetFirst():GetLevel())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c80015100.scfilter,tp,LOCATION_MZONE,0,1,1,nil,cg:GetFirst())
end
function c80015100.lvop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup()then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c80015100.e2filter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE+LOCATION_HAND) and c:GetPreviousControler()==tp
end
function c80015100.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c80015100.e2filter,1,nil,tp)
end
function c80015100.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c80015100.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c80015100.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80015100.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg=Duel.SelectTarget(tp,c80015100.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c80015100.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
