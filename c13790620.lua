--kruiball	
function c13790620.initial_effect(c)
--pos
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13790620,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c13790620.spcost)
	e1:SetCondition(c13790620.spcon)
	e1:SetTarget(c13790620.sptg)
	e1:SetOperation(c13790620.spop)
	c:RegisterEffect(e1)
	--ritual material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	c:RegisterEffect(e2)
end
function c13790620.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c13790620.spcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp
end
function c13790620.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttacker()
	if chk==0 then return at:IsCanTurnSet() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,at,1,0,0)
end
function c13790620.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local at=Duel.GetAttacker()
	if at:IsControler(1-tp) and at:IsRelateToBattle() and at:IsFaceup() then
	Duel.ChangePosition(at,POS_FACEDOWN_DEFENCE)
	end
end