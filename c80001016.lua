--Raidraptor - Booster Strix
function c80001016.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80001016,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c80001016.nacon)
	e1:SetCost(c80001016.nacost)
	e1:SetTarget(c80001016.natg)
	e1:SetOperation(c80001016.naop)
	c:RegisterEffect(e1)
end

function c80001016.nacon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at:IsControler(tp) and at:IsFaceup() and at:IsSetCard(0xba)
end
function c80001016.nacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80001016.natg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttacker():IsOnField() end
	local at=Duel.GetAttacker()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,at,1,0,0)
end
function c80001016.naop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsFaceup() and tc:IsAttackable() and not tc:IsStatus(STATUS_ATTACK_CANCELED) then 
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
