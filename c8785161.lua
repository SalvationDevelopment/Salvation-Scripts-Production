--Scripted by Eerie Code
--Raidraptor - Wild Vulture
function c8785161.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8785161,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c8785161.spcon)
	e1:SetCost(c8785161.spcost)
	e1:SetTarget(c8785161.sptg)
	e1:SetOperation(c8785161.spop)
	c:RegisterEffect(e1)
	if not c8785161.global_check then
		c8785161.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetLabel(8785161)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetLabel(8785161)
		Duel.RegisterEffect(ge2,0)
	end
end

function c8785161.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(8785161)>0
end
function c8785161.spfilter1(c,e,tp)
	return c:IsSetCard(0xba) and c:IsType(TYPE_MONSTER) and c:GetLevel()>0 and c:GetLevel()<6
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
		and Duel.IsExistingMatchingCard(c8785161.spfilter2,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,c,e,tp,c:GetLevel())
end
function c8785161.spfilter2(c,e,tp,lv)
	return c:IsSetCard(0xba) and c:IsType(TYPE_MONSTER) and c:GetLevel()+lv==6
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c8785161.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end 
function c8785161.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c8785161.spfilter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c8785161.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c8785161.spfilter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g1:GetCount()>0 then
		local tc=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c8785161.spfilter2,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,tc,e,tp,tc:GetLevel())
		g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end