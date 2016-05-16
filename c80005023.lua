--Ruins of the Great Divine Dragon
function c80005023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80005023,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c80005023.discon)
	e2:SetTarget(c80005023.distg)
	e2:SetOperation(c80005023.disop)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80005023,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c80005023.tkcost)
	e3:SetTarget(c80005023.tktg)
	e3:SetOperation(c80005023.tkop)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80005023,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(c80005023.thcost)
	e4:SetTarget(c80005023.thtg)
	e4:SetOperation(c80005023.thop)
	c:RegisterEffect(e4)
end

function c80005023.confilter(c)
	return (c:GetLevel()==7 or c:GetLevel()==8) and c:IsRace(RACE_DRAGON)
end
function c80005023.discon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_GRAVE)
		and Duel.IsExistingMatchingCard(c80005023.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c80005023.filter(c)
	return c:IsFaceup()
end
function c80005023.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c80005023.filter,1,nil) end
	local g=eg:Filter(c80005023.filter,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c80005023.disfilter(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c80005023.disop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c80005023.disfilter,nil,e)
	local tc=g:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end

function c80005023.desfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c80005023.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80005023.desfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c80005023.desfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c80005023.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,80105023,0,0x4011,0,0,1,RACE_DRAGON,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c80005023.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e)
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,80105023,0,0x4011,0,0,1,RACE_DRAGON,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,80105023)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end

function c80005023.thfilter(c)
	return (c:GetLevel()==7 or c:GetLevel()==8) and c:IsRace(RACE_DRAGON) and c:IsAbleToGraveAsCost()
end
function c80005023.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80005023.thfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c80005023.thfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c80005023.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c80005023.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end