--Paladin of Felgrand
function c80005002.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80005002,0))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c80005002.eqtg)
	e1:SetOperation(c80005002.eqop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(c80005002.econ)
	e3:SetValue(c80005002.efilter)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80005002,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c80005002.spcost)
	e4:SetTarget(c80005002.sptg)
	e4:SetOperation(c80005002.spop)
	c:RegisterEffect(e4)
end

function c80005002.filter(c)
	return (c:GetLevel()==7 or c:GetLevel()==8) and c:IsRace(RACE_DRAGON)
end
function c80005002.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_HAND+LOCATION_DECK) and c80005002.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c80005002.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c80005002.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local tc=Duel.SelectMatchingCard(tp,c80005002.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
		local g=tc:GetFirst()
		if not tc or not Duel.Equip(tp,g,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c80005002.eqlimit)
		g:RegisterEffect(e1)
	end
end
function c80005002.eqlimit(e,c)
	return e:GetOwner()==c
end

function c80005002.econ(e)
	return e:GetHandler():GetEquipCount()>0
end
function c80005002.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end

function c80005002.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.CheckReleaseGroup(tp,nil,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectReleaseGroup(tp,nil,1,1,c)
	rg:AddCard(c)
	Duel.Release(rg,REASON_COST)
end
function c80005002.spfilter(c,e,tp)
	return (c:GetLevel()==7 or c:GetLevel()==8) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80005002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c80005002.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingTarget(c80005002.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c80005002.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c80005002.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end