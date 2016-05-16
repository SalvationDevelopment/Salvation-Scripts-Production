--Celtic Sacred Guard
function c80014004.initial_effect(c)
	--atklimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetCondition(c80014004.atkcon)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80014004,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c80014004.sptg)
	e2:SetOperation(c80014004.spop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80014004,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCondition(c80014004.hdcon)
	e3:SetTarget(c80014004.hdtg)
	e3:SetOperation(c80014004.hdop)
	c:RegisterEffect(e3)
end

function c80014004.atkcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)~=0
end

function c80014004.spfilter(c,e,tp)
	return c:IsSetCard(0xe1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80014004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80014004.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
end
function c80014004.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80014004.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c80014004.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler()==Duel.GetAttacker()
end
function c80014004.drfilter(c)
	return c:IsSetCard(0xe1) and c:IsFaceup()
end
function c80014004.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroupCount(c80014004.drfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g)
end
function c80014004.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroupCount(c80014004.drfilter,tp,LOCATION_MZONE,0,nil)
	if Duel.IsPlayerCanDraw(tp,g) then
		Duel.Draw(tp,g,REASON_EFFECT)
	end
end