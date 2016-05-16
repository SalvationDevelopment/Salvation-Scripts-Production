--Amorphage Irritum
function c80001031.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c80001031.mtcon)
	e1:SetOperation(c80001031.mtop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetTargetRange(0xff,0xff)
	e2:SetCondition(c80001031.rmcon)
	e2:SetTarget(c80001031.rmlimit)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	--no extra
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetTarget(c80001031.splimit)
	c:RegisterEffect(e3)
end

function c80001031.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c80001031.mtop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,nil)
	local select=1
	if g:GetCount()>0 then
		select=Duel.SelectOption(tp,aux.Stringid(80001031,0),aux.Stringid(80001031,1))
	end
	if select==0 then
		local tc=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Release(tc,REASON_COST)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end

function c80001031.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe1)
end
function c80001031.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c80001031.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c80001031.rmlimit(e,c,tp)
	return not c:IsSetCard(0xe1)
end

function c80001031.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0xe1)
end