--Scripted by Eerie Code
--Royal Swamp Couple
function c92723496.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(92723496,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,92723496)
	e1:SetCost(c92723496.cost)
	e1:SetTarget(c92723496.target)
	e1:SetOperation(c92723496.operation)
	c:RegisterEffect(e1)
end

function c92723496.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c92723496.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c92723496.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c92723496.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c92723496.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsRace(RACE_WYRM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c92723496.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c92723496.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c92723496.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c92723496.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
