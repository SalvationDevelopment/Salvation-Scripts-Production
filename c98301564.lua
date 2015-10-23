--Liberating Ariadne
--Scripted by Ragna_Edeg
function c98301564.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_LPCOST_REPLACE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c98301564.repcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DISCARD_HAND_REPLACE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c98301564.thcon)
	e4:SetTarget(c98301564.thtg)
	e4:SetOperation(c98301564.thop)
	c:RegisterEffect(e4)
end
function c98301564.repcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return rc:IsType(TYPE_COUNTER)
end
function c98301564.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c98301564.thfil(c)
	return c:IsType(TYPE_COUNTER) and c:IsAbleToHand()
end
function c98301564.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c98301564.thfil,tp,LOCATION_DECK,0,3,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c98301564.thop(e,tp,eg,ep,ev,re,r,rp)
	local sg1=Duel.SelectMatchingCard(tp,c98301564.thfil,tp,LOCATION_DECK,0,3,3,nil)
	if sg1:GetCount()==3 then
		Duel.ConfirmCards(1-tp,sg1)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=sg1:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
		if tc:IsAbleToHand() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
	Duel.ShuffleDeck(tp)
end