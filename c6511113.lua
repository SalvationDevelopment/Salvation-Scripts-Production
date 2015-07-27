--Scripted by Eerie Code
--Traptrix Rafflesia
function c6511113.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--Unaffected by Traps
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c6511113.indcon)
	e1:SetValue(c6511113.indval)
	c:RegisterEffect(e1)
	--Immunity
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c6511113.immtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c6511113.immtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c6511113.immtg)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--Activate Trap
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c6511113.condition)
	e5:SetCost(c6511113.cost)
	e5:SetTarget(c6511113.target)
	e5:SetOperation(c6511113.operation)
	c:RegisterEffect(e5)
end

function c6511113.indcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c6511113.indval(e,te)
	return te:IsActiveType(TYPE_TRAP)
end

function c6511113.immtg(e,c)
	return c:GetCode()~=6511113 and c:IsSetCard(0x108a)
end

function c6511113.filter(c)
	return c:GetType()==TYPE_TRAP and (c:IsSetCard(0x4c) or c:IsSetCard(0x89)) and c:CheckActivateEffect(false,false,false)~=nil and c:IsAbleToGraveAsCost()
end
function c6511113.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c6511113.filter,tp,LOCATION_DECK,0,1,nil)
end
function c6511113.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c6511113.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6511113.filter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c6511113.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	local te,eg,ep,ev,re,r,rp=tc:CheckActivateEffect(false,true,true)
	local tg=te:GetTarget()
	e:SetLabelObject(te)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	--Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	Duel.SendtoGrave(tc,REASON_EFFECT+REASON_COST)
end
function c6511113.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end