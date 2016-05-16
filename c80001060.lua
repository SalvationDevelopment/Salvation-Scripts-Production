--Light Guidance
function c80001060.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c80001060.condition)
	e1:SetTarget(c80001060.target)
	e1:SetOperation(c80001060.operation)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetOperation(c80001060.checkop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(c80001060.remop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetProperty(EFFECT_FLAG_OATH)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c80001060.ftarget)
	c:RegisterEffect(e4)
	--multi attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_EXTRA_ATTACK)
	e5:SetCondition(c80001060.multcon)
	e5:SetValue(c80001060.multval)
	c:RegisterEffect(e5)
end

function c80001060.confilter(c)
	return c:IsFaceup() and c:IsCode(80001060)
end
function c80001060.condition(e)
	return not Duel.IsExistingMatchingCard(c80001060.confilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_GRAVE,0,3,nil,0xdd)
end
function c80001060.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xdd)
end
function c80001060.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c80001060.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c80001060.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c80001060.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c80001060.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function c80001060.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		Duel.Equip(tp,c,tc)
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c80001060.eqlimit)
		e1:SetLabelObject(tc)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		tc:RegisterFlagEffect(80001060,RESET_EVENT+0x1fe0000,0,1)
	end
end

function c80001060.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c80001060.remop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=0 then return end
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

function c80001060.ftarget(e,c)
	return c:GetFlagEffect(80001060)==0
end

function c80001060.multcon(e)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,0xdd)
end
function c80001060.multval(e)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,0xdd)-1
end