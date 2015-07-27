--Scripted by Eerie Code
--Red Dragon Archfiend Scarright
function c80666118.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(70902743)
	c:RegisterEffect(e1)
	--Destroy+Damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80666118,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c80666118.destg)
	e2:SetOperation(c80666118.desop)
	c:RegisterEffect(e2)
end

function c80666118.desfilter(c,atk)
	return c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:GetAttack()<=atk and c:IsDestructable()
end
function c80666118.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c80666118.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),e:GetHandler():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*500)
end
function c80666118.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80666118.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),e:GetHandler():GetAttack())
	local ct=Duel.Destroy(g,REASON_EFFECT)
	Duel.Damage(1-tp,ct*500,REASON_EFFECT)
end