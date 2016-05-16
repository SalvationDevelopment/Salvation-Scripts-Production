--ＲＵＭ－スキップ・フォース - Rank-Up-Magic Skip Force
function c80001058.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80001058,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c80001058.target)
	e1:SetOperation(c80001058.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80001058,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(c80001058.spcon)
	e2:SetCost(c80001058.spcost)
	e2:SetTarget(c80001058.sptg)
	e2:SetOperation(c80001058.spop)
	c:RegisterEffect(e2)
end
function c80001058.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xba)
		and Duel.IsExistingMatchingCard(c80001058.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+2)
end
function c80001058.filter2(c,e,tp,mc,rk)
	return c:GetRank()==rk and c:IsSetCard(0xba) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c80001058.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c80001058.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c80001058.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c80001058.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c80001058.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80001058.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+2)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
function c80001058.spcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and Duel.GetTurnPlayer()==tp
end
function c80001058.cfilter(c)
	return c:IsSetCard(0xba) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c80001058.spfilter(c,e,tp)
	return c:IsSetCard(0xba) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80001058.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c80001058.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
    local sg=Duel.GetMatchingGroup(c80001058.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
    local g=nil
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    if sg:GetCount()>1 then
        g=Duel.SelectMatchingCard(tp,c80001058.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    else
        g=Duel.SelectMatchingCard(tp,c80001058.cfilter,tp,LOCATION_GRAVE,0,1,1,sg:GetFirst())
    end
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c80001058.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c80001058.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c80001058.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c80001058.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c80001058.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
