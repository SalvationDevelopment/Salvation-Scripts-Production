--Ancient White Stone
function c80001022.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetOperation(c80001022.regop)
	c:RegisterEffect(e1)
	--spsummon Blue Eyes
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(c80001022.spcon)
	e2:SetTarget(c80001022.target)
	e2:SetOperation(c80001022.activate)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80001022,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,80001022)
	e3:SetCost(c80001022.thcost)
	e3:SetTarget(c80001022.thtg)
	e3:SetOperation(c80001022.thop)
	c:RegisterEffect(e3)
end

function c80001022.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(80001022,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end

function c80001022.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(80001022)>0
end
function c80001022.spfilter(c,e,tp)
	return c:IsSetCard(0xdd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80001022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c80001022.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c80001022.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80001022.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c80001022.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80001022.filter(c)
	return c:IsSetCard(0xdd) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c80001022.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c80001022.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80001022.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c80001022.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c80001022.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end