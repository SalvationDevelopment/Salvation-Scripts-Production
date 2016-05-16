--Crystal Wing Synchro Dragon
function c80001049.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80001049,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c80001049.condition)
	e1:SetTarget(c80001049.target)
	e1:SetOperation(c80001049.operation)
	c:RegisterEffect(e1)
	--attack up (battle)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80001049,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_F+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetCondition(c80001049.con)
	e2:SetCost(c80001049.cost)
	e2:SetOperation(c80001049.op)
	c:RegisterEffect(e2)
end

function c80001049.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc~=c
		and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c80001049.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c80001049.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateActivation(ev)
	local rc=re:GetHandler()
	local atk=rc:GetBaseAttack()
	if rc:IsRelateToEffect(re) then 
		if Duel.Destroy(rc,REASON_EFFECT)~=0 and atk>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
end

function c80001049.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:GetFlagEffect(80001049)==0 and (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c)
		and bc and bc:IsLevelAbove(5)
end
function c80001049.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(80001049,RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c80001049.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local atk=bc:GetAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(atk)
	c:RegisterEffect(e1)
end