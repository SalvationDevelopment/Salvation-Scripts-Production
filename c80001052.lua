--Blue-Eyes Spirit Dragon
function c80001052.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xdd),1)
	c:EnableReviveLimit()
	--sp summon space limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_MAX_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(c80001052.value)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80001052,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1)
	e2:SetCondition(c80001052.discon)
	e2:SetTarget(c80001052.distg)
	e2:SetOperation(c80001052.disop)
	c:RegisterEffect(e2)
	--special summon synchro
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80001052,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c80001052.spcon)
	e3:SetCost(c80001052.spcost)
	e3:SetTarget(c80001052.sptarget)
	e3:SetOperation(c80001052.spoperation)
	c:RegisterEffect(e3)
end

function c80001052.value(e,fp,rp,r)
	 if r~=LOCATION_REASON_TOFIELD then return 5 end
	 local limit=Duel.GetFieldGroupCount(rp,LOCATION_MZONE,0)+1
	 if limit>5 then limit = 5 end
	 return limit>0 and limit or 5
end

function c80001052.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return Duel.IsChainNegatable(ev) and loc==LOCATION_GRAVE
end
function c80001052.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c80001052.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

function c80001052.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c80001052.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(80001052)
end
function c80001052.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c80001052.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c80001052.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c80001052.spoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80001052.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetOperation(c80001052.desop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		tc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
function c80001052.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end