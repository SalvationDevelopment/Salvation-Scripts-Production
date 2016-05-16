--Gandora X the Dragon of Destruction
function c80014001.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80014001,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c80014001.destg)
	e1:SetOperation(c80014001.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c80014001.descon)
	c:RegisterEffect(e2)
	--halve lp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80014001,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c80014001.lpc)
	e3:SetOperation(c80014001.lpcop)
	c:RegisterEffect(e3)
end

function c80014001.descon(e)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c80014001.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c80014001.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local tg=g:GetMaxGroup(Card.GetAttack)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local atk=tg:GetFirst():GetAttack()
		if Duel.Damage(1-tp,atk,REASON_EFFECT) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+0xff0000)
			c:RegisterEffect(e1)
		end
	end
end

function c80014001.lpc(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c80014001.lpcop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,math.ceil(lp/2))
end