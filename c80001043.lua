--Bloom Prima the Melodious Choir
function c80001043.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x109b),aux.FilterBoolFunction(Card.IsSetCard,0x9b),1,63,true)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c80001043.matcheck)
	c:RegisterEffect(e1)
	--double attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetTarget(c80001043.thtg)
	e3:SetOperation(c80001043.thop)
	c:RegisterEffect(e3)
end

function c80001043.matcheck(e,c)
	local ct=c:GetMaterial():GetCount()
	if ct>0 then
		local ae=Effect.CreateEffect(c)
		ae:SetType(EFFECT_TYPE_SINGLE)
		ae:SetCode(EFFECT_UPDATE_ATTACK)
		ae:SetValue(ct*300)
		ae:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(ae)
	end
end

function c80001043.filter(c)
	return c:IsSetCard(0x9b) and c:IsAbleToHand()
end
function c80001043.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c80001043.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c80001043.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c80001043.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c80001043.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end