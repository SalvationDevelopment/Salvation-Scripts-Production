--Moon-Light Lio Dancer
function c80001048.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,80001047,aux.FilterBoolFunction(Card.IsSetCard,0xdf),2,false,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c80001048.indval)
	c:RegisterEffect(e3)
	--double attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80001048,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c80001048.descon)
	e5:SetTarget(c80001048.destg)
	e5:SetOperation(c80001048.desop)
	c:RegisterEffect(e5)
end

function c80001048.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end

function c80001048.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()
end
function c80001048.filter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsDestructable()
end
function c80001048.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80001048.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c80001048.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c80001048.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80001048.filter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end