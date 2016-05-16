--Steel Cavalry of Dinon
function c80002000.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--halve att/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c80002000.target)
	e1:SetOperation(c80002000.operation)
	c:RegisterEffect(e1)
end

function c80002000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=e:GetHandler():GetBattleTarget()
	if chk ==0 then	return d and d:IsFaceup() and d:IsType(TYPE_PENDULUM) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,0,0)
end
function c80002000.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetAttack()/2)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENCE_FINAL)
		e2:SetValue(c:GetDefence()/2)
		c:RegisterEffect(e2)
	end
end
