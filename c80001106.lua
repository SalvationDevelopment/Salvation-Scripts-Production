--Bug Matrix
function c80001106.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_INSECT))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e3)
	--material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80001106,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,80001106)
	e4:SetTarget(c80001106.mattg)
	e4:SetOperation(c80001106.matop)
	c:RegisterEffect(e4)
end

function c80001106.xyzfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_INSECT)
		and Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_HAND,0,1,nil,RACE_INSECT)
end
function c80001106.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c80001106.xyzfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c80001106.xyzfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c80001106.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c80001106.matop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,Card.IsRace,tp,LOCATION_HAND,0,1,1,nil,RACE_INSECT)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end