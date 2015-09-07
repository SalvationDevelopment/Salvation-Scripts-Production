--Reject Reborn
function c72090671.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c72090671.condition)
	e1:SetOperation(c72090671.activate)
	c:RegisterEffect(e1)
end
function c72090671.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c72090671.filter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and Duel.IsExistingMatchingCard(c72090671.filter2,tp,LOCATION_GRAVE,0,1,c,e,tp)s
end
function c72090671.filter2(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c72090671.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	Duel.BreakEffect()
	if  Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsExistingMatchingCard(c72090671.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
	and Duel.SelectYesNo(tp,aux.Stringid(72090671,0)) then
		local g=Duel.SelectTarget(tp,c72090671.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		local g2=Duel.SelectTarget(tp,c72090671.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		g:Merge(g2)
		if g:GetCount()~=2 then return false end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end