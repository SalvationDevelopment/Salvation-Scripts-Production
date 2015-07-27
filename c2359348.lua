--Scripted by Eerie Code
--Pendulum Area
function c2359348.initial_effect(c)
	--Prevent Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c2359348.condition)
	e1:SetTarget(c2359348.target)
	e1:SetOperation(c2359348.operation)
	c:RegisterEffect(e1)
end

function c2359348.cfilter(c)
	return c:IsFacedown() or not c:IsType(TYPE_PENDULUM)
end
function c2359348.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c2359348.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c2359348.filter(c)
	return c:GetSequence()==6 or c:GetSequence()==7
end
function c2359348.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c2359348.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c2359348.filter,tp,LOCATION_SZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c2359348.filter,tp,LOCATION_SZONE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c2359348.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==2 and Duel.Destroy(tg,REASON_EFFECT)>0 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,1)
		e2:SetTarget(c2359348.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c2359348.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)~=SUMMON_TYPE_PENDULUM
end