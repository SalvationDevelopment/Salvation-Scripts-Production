--ＤＤ魔導賢者ニュートン - D/D Magical Astronomer Newton
function c29302550.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(aux.nfbdncon)
	e2:SetTarget(c29302550.splimit)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c29302550.e3condition)
	e3:SetOperation(c29302550.e3operation)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(29302550,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,29302550)
	e4:SetCost(c29302550.thcost)
	e4:SetTarget(c29302550.thtg)
	e4:SetOperation(c29302550.thop)
	c:RegisterEffect(e4)
end
function c29302550.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xaf) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c29302550.e3condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsType(TYPE_TRAP) then return false end
	return aux.damcon1(e,tp,eg,ep,ev,re,r,rp)
end
function c29302550.e3operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(29302550,2)) then
		Duel.NegateEffect(ev)
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	else end
end
function c29302550.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c29302550.thfilter(c)
	return (c:IsSetCard(0xae) or c:IsSetCard(0xaf)) and not c:IsCode(29302550) and c:IsAbleToHand()
end
function c29302550.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c29302550.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c29302550.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c29302550.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c29302550.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
