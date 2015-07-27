--Scripted by Eerie Code
--Supreme Warrior Ritual
function c14094090.initial_effect(c)
	aux.AddRitualProcEqual2(c,c14094090.ritual_filter)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14094090,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,14094090+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c14094090.spcon)
	e1:SetCost(c14094090.spcost)
	e1:SetTarget(c14094090.sptg)
	e1:SetOperation(c14094090.spop)
	c:RegisterEffect(e1)
end

function c14094090.ritual_filter(c)
	return c:IsSetCard(0xd0) and bit.band(c:GetType(),0x81)==0x81
end

function c14094090.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetTurnID()~=Duel.GetTurnCount()
end
function c14094090.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c14094090.cfilter,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_LIGHT) and Duel.IsExistingMatchingCard(c14094090.cfilter,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_DARK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c14094090.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,ATTRIBUTE_LIGHT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c14094090.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,ATTRIBUTE_DARK)
	g1:Merge(g2)
	--g1:Merge(e:GetHandler())
	g1:AddCard(e:GetHandler())
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c14094090.cfilter(c,att)
	return c:IsAttribute(att) and c:IsAbleToRemoveAsCost()
end
function c14094090.spfilter(c,e,tp)
	return c:IsSetCard(0xd0) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c14094090.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c14094090.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c14094090.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c14094090.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
end