--Lord Gaia the Fierce Knight
function c80014002.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c80014002.spcon)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80014002,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c80014002.thcon)
	e2:SetTarget(c80014002.thtg)
	e2:SetOperation(c80014002.thop)
	c:RegisterEffect(e2)
end

function c80014002.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and	Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function c80014002.cfilter(c,tp,atk)
	return c:IsFaceup() and c:IsControler(tp) and c:GetAttack()>atk
end
function c80014002.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c80014002.cfilter,1,nil,1-tp,e:GetHandler():GetAttack())
end
function c80014002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,0,0)
end
function c80014002.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(700)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end