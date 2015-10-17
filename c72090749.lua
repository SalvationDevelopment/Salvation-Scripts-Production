-- Hi-Speedroid Mach Hagoita
function c72090749.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--level up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72090749,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c72090749.lcost)
	e1:SetTarget(c72090749.ltg)
	e1:SetOperation(c72090749.lpop)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72090749,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,72090749)
	e2:SetCondition(c72090749.spcon)
	e2:SetTarget(c72090749.sptg)
	e2:SetOperation(c72090749.spop)
	c:RegisterEffect(e2)
	
end
function c72090749.lcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c72090749.filter(c)
	return c:IsFaceup()
end
function c72090749.ltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72090749.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c72090749.lpop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c72090749.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c72090749.hsfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2016) and c:IsType(TYPE_TUNER)
end
function c72090749.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c72090749.hsfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c72090749.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c72090749.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_WIND)
end
function c72090749.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c72090749.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end