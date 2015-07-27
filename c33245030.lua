--Scripted by Eerie Code
--Kuriball
function c33245030.initial_effect(c)
	--ritual material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	c:RegisterEffect(e0)
	--Change position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33245030,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c33245030.condition)
	e1:SetCost(c33245030.cost)
	e1:SetTarget(c33245030.target)
	e1:SetOperation(c33245030.operation)
	c:RegisterEffect(e1)
end

function c33245030.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp
end
function c33245030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c33245030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetAttacker()
	if chk==0 then return tg:IsOnField() and tg:IsPosition(POS_ATTACK) end
end
function c33245030.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENCE)
	end
end