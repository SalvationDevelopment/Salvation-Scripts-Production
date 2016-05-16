--ＲＲ－アルティメット・ファルコン - Raidraptor - Ultimate Falcon
function c80001053.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WINDBEAST),10,3)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c80001053.efilter)
	c:RegisterEffect(e1)
	--atkdown
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c80001053.atkcost)
	e2:SetOperation(c80001053.atkop)
	c:RegisterEffect(e2)
	--atkdown 2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80001053,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c80001053.atkcon)
	e3:SetTarget(c80001053.target)
	e3:SetOperation(c80001053.atkop2)
	c:RegisterEffect(e3)
end
function c80001053.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80001053.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80001053.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-1000)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(c80001053.aclimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c80001053.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)
end
function c80001053.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xba)
end
function c80001053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
	if g==true then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
end
function c80001053.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if tc:GetCount()>0 then
		local g=tc:GetFirst()
		while g do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetTargetRange(0,LOCATION_MZONE)
			e1:SetValue(-1000)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			g:RegisterEffect(e1,tp)
			g=tc:GetNext()
		end
	else
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
	end
end