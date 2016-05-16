--Amorphage Infection
function c80001063.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk/def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe1))
	e2:SetValue(c80001063.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80001063,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_RELEASE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,80001063)
	e4:SetCondition(c80001063.thcon)
	e4:SetTarget(c80001063.thtg)
	e4:SetOperation(c80001063.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_DESTROYED)
	c:RegisterEffect(e5)
end

function c80001063.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,0xe1)*100
end

function c80001063.filter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT+REASON_RELEASE) 
		and c:IsPreviousLocation(LOCATION_MZONE+LOCATION_HAND) 
		and c:GetPreviousControler()==tp
end
function c80001063.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c80001063.filter,1,nil,tp)
end
function c80001063.thfilter(c)
	return c:IsSetCard(0xe1) and c:IsAbleToHand()
end
function c80001063.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80001063.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80001063.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80001063.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end