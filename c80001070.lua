--Re-Dice
function c80001070.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c80001070.target)
	e1:SetOperation(c80001070.activate)
	c:RegisterEffect(e1)
	--synchro effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c80001070.sccost)
	e2:SetTarget(c80001070.sctg)
	e2:SetOperation(c80001070.scop)
	c:RegisterEffect(e2)
end

function c80001070.filter(c,e,tp)
	return c:IsSetCard(0x2016) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80001070.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c80001070.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c80001070.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c80001070.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c80001070.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
		local d=Duel.TossDice(tp,1)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(d)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
end

function c80001070.mfilter(c)
	return c:IsSetCard(0x2016) and c:IsType(TYPE_TUNER)
end
function c80001070.mfilter2(c)
	return c:IsHasEffect(EFFECT_HAND_SYNCHRO) and c:IsType(TYPE_MONSTER)
end
function c80001070.cfilter(c,syn)
	local b1=true
	if c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
		b1=Duel.CheckTunerMaterial(syn,c,nil,c80001070.mfilter,1,99)
	end
	return b1 and syn:IsSynchroSummonable(c) and syn:IsAttribute(ATTRIBUTE_WIND)
end
function c80001070.spfilter(c,mg)
	return mg:IsExists(c80001070.cfilter,1,nil,c)
end
function c80001070.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80001070.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c80001070.mfilter,tp,LOCATION_MZONE,0,nil)
		local exg=Duel.GetMatchingGroup(c80001070.mfilter2,tp,LOCATION_MZONE,0,nil)
		mg:Merge(exg)
		return Duel.IsExistingMatchingCard(c80001070.spfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c80001070.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c80001070.mfilter,tp,LOCATION_MZONE,0,nil)
	local exg=Duel.GetMatchingGroup(c80001070.mfilter2,tp,LOCATION_MZONE,0,nil)
	mg:Merge(exg)
	local g=Duel.GetMatchingGroup(c80001070.spfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=mg:FilterSelect(tp,c80001070.cfilter,1,1,nil,sg:GetFirst())
		Duel.SynchroSummon(tp,sg:GetFirst(),tg:GetFirst())
	end
end
