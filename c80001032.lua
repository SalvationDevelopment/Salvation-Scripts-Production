--Dinomist Spinos
function c80001032.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c80001032.reptg)
	e1:SetValue(c80001032.repval)
	e1:SetOperation(c80001032.repop)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80001032,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c80001032.condition)
	e2:SetCost(c80001032.cost)
	e2:SetOperation(c80001032.operation)
	c:RegisterEffect(e2)
	--multiatk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80001032,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c80001032.atkcon)
	e3:SetCost(c80001032.cost)
	e3:SetTarget(c80001032.atktg)
	e3:SetOperation(c80001032.atkop)
	c:RegisterEffect(e3)
end

function c80001032.filter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0xd8)
		and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp))
end
function c80001032.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c80001032.filter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectYesNo(tp,aux.Stringid(80001032,0))
end
function c80001032.repval(e,c)
	return c80001032.filter(c,e:GetHandlerPlayer())
end
function c80001032.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end

function c80001032.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and e:GetHandler():GetEffectCount(EFFECT_DIRECT_ATTACK)==0
end
function c80001032.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,e:GetHandler(),0xd8) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,e:GetHandler(),0xd8)
	Duel.Release(g,REASON_COST)
end
function c80001032.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end

function c80001032.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c80001032.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c80001032.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
