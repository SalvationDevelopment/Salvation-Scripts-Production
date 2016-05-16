--Bug Emergency
function c80001074.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,80001074+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c80001074.target)
	e1:SetOperation(c80001074.activate)
	c:RegisterEffect(e1)
	--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80001074,0))
	e2:SetCategory(CATEGORY_LVCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c80001074.cost)
	e2:SetTarget(c80001074.lvtg)
	e2:SetOperation(c80001074.lvop)
	c:RegisterEffect(e2)
end

function c80001074.filter(c,e,tp)
	return c:GetLevel()==3 and c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80001074.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c80001074.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c80001074.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c80001074.filter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c80001074.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if g:GetCount()<=ct then
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
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
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end

function c80001074.cfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsAbleToRemoveAsCost() and c:GetRank()~=3
end
function c80001074.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c80001074.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c80001074.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	e:SetLabel(g:GetFirst():GetRank())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c80001074.lvfilter(c)
	return c:IsFaceup() and c:GetLevel()==3 and c:IsRace(RACE_INSECT)
end
function c80001074.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80001074.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c80001074.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c80001074.lvfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c80001074.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c80001074.splimit(e,c)
	return not c:IsRace(RACE_INSECT)
end