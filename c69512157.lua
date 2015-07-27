--Scripted by Eerie Code
--Vector Pendulum, the Dracoruler
function c69512157.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(0,LOCATION_SZONE)
	e4:SetTarget(c69512157.distg)
	c:RegisterEffect(e4)
	--disable effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_PZONE)
	e5:SetOperation(c69512157.disop)
	c:RegisterEffect(e5)
end

function c69512157.distg(e,c)
	return c:IsType(TYPE_PENDULUM) and (c:GetSequence()==6 or c:GetSequence()==7)
end
function c69512157.disop(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LOCATION_PZONE and not ep==tp and re:IsActiveType(TYPE_PENDULUM) then
		Duel.NegateEffect(ev)
	end
end