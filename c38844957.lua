--Scripted by Eerie Code
--Urgent Ritual Art
function c38844957.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c38844957.condition)
	e1:SetTarget(c38844957.target)
	e1:SetOperation(c38844957.activate)
	c:RegisterEffect(e1)
end

function c38844957.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL)
end
function c38844957.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c38844957.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c38844957.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and c:CheckActivateEffect(false,false,false)~=nil and c:IsAbleToRemove()
end
function c38844957.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c38844957.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
end
function c38844957.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c38844957.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		local tc=g:GetFirst()
		local tpe=tc:GetType()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(tpe)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		c:RegisterEffect(e1)
		local te=tc:GetActivateEffect()
		local tg=te:GetTarget()
		local op=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		Duel.ClearTargetCard()
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		Duel.BreakEffect()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end 
	end
end