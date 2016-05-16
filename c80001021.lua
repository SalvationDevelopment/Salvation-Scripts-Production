--Priest with Eyes of Blue
function c80001021.initial_effect(c)
	--salvage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80001021,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c80001021.target)
	e1:SetOperation(c80001021.operation)
	c:RegisterEffect(e1)
	--spsummon Blue Eyes
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,80001021)
	e2:SetCost(c80001021.cost)
	e2:SetTarget(c80001021.target2)
	e2:SetOperation(c80001021.activate)
	c:RegisterEffect(e2)
end

function c80001021.filter(c)
	return c:IsType(TYPE_TUNER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:GetLevel()==1 and c:IsAbleToHand()
end
function c80001021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c80001021.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80001021.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c80001021.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c80001021.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

function c80001021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,1,REASON_COST)
end
function c80001021.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
		and Duel.IsExistingMatchingCard(c80001021.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c80001021.spfilter(c,e,tp)
	return c:IsSetCard(0xdd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80001021.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c80001021.cfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c80001021.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c80001021.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c80001021.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_GRAVE) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80001021.spfilter,tp,LOCATION_GRAVE,0,1,1,tc,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end