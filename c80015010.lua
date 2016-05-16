--原初の叫喚 - Primal Cry
function c80015010.initial_effect(c)
	aux.AddRitualProcGreaterCode(c,80015100)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c80015010.spcon)
	e1:SetCost(c80015010.spcost)
	e1:SetTarget(c80015010.sptg)
	e1:SetOperation(c80015010.spop)
	c:RegisterEffect(e1)
end
c80015010.fit_monster={80015100}
function c80015010.filter(c,e,tp,tid)
	return c:GetTurnID()==tid and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80015010.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c80015010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80015010.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tid=Duel.GetTurnCount()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsPreviousLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c80015010.filter(chkc,e,tp,tid) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c80015010.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,tid) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c80015010.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tid)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c80015010.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
