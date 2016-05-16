-- チューナーズ・ハイ - Tuner's High
--トランスターン
function c80001067.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCost(c80001067.cost)
	e1:SetTarget(c80001067.target)
	e1:SetOperation(c80001067.activate)
	c:RegisterEffect(e1)
end
function c80001067.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c80001067.cfilter(c,e,tp)
	local lv=c:GetOriginalLevel()
	local rc=c:GetOriginalRace()
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and lv>0
        and c:IsDiscardable() and c:IsAbleToGraveAsCost()
        and Duel.IsExistingMatchingCard(c80001067.spfilter,tp,LOCATION_DECK,0,1,nil,lv+1,rc,c:GetOriginalAttribute(),e,tp)
end
function c80001067.spfilter(c,lv,rc,att,e,tp)
	return c:GetLevel()==lv and c:IsRace(rc) and c:IsAttribute(att) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80001067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c80001067.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	e:SetLabel(0)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c80001067.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c80001067.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80001067.spfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel()+1,tc:GetRace(),tc:GetAttribute(),e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
