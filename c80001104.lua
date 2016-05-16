--Amorphage Hyper
function c80001104.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c80001104.mtcon)
	e1:SetOperation(c80001104.mtop)
	c:RegisterEffect(e1)
	--no effect damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetValue(c80001104.damval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e3)
	--no extra
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c80001104.sumcon)
	e4:SetOperation(c80001104.sumlimit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_FLIP)
	e5:SetOperation(c80001104.sumlimit)
	c:RegisterEffect(e5)
end

function c80001104.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c80001104.mtop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,nil)
	local select=1
	if g:GetCount()>0 then
		select=Duel.SelectOption(tp,aux.Stringid(80001104,0),aux.Stringid(80001104,1))
	end
	if select==0 then
		local tc=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Release(tc,REASON_COST)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end

function c80001104.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end

function c80001104.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe1)
end
function c80001104.chaincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c80001104.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c80001104.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(aux.FALSE)
end

function c80001104.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c80001104.sumlimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetTarget(c80001104.splimit)
	e:GetHandler():RegisterEffect(e1)
end
function c80001104.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0xe1)
end