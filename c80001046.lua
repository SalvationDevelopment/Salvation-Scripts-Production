--Moon-Light Cat Dancer
--Credit to Michael Lawrence Dee for the multiple attacks script
function c80001046.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0xdf),2,false)
	--not destroyed by battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Multiple attacks
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80001046,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c80001046.atkcon)
	e2:SetCost(c80001046.atkcost)
	e2:SetOperation(c80001046.atkop)
	c:RegisterEffect(e2)
	--dmg
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80001046,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetTarget(c80001046.target)
	e3:SetOperation(c80001046.operation)
	c:RegisterEffect(e3)
end

function c80001046.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c80001046.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,e:GetHandler(),0xdf) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,e:GetHandler(),0xdf)
	Duel.Release(g,REASON_COST)
end
function c80001046.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(100)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_DAMAGE_STEP_END)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetOperation(c80001046.unop)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_DAMAGE_CALCULATING)
		e3:SetCondition(c80001046.indescon)
		e3:SetOperation(c80001046.indesop)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetRange(LOCATION_MZONE)
		e4:SetTargetRange(0,LOCATION_MZONE)
		e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
		e4:SetTarget(c80001046.valtg)
		e4:SetValue(c80001046.vala)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e4)
	end
end
function c80001046.unop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:GetFlagEffect(80021046)==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(80021046,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE,0,1)
	end
	if bc then
		if bc:GetFlagEffect(80001046)>0 then
			bc:RegisterFlagEffect(80011046,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE,0,1)
		else
			bc:RegisterFlagEffect(80001046,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE,0,1)
		end
	end
end
function c80001046.valtg(e,c)
	return c:GetFlagEffect(80011046)>0
end
function c80001046.vala(e,c)
	return c==e:GetHandler()
end
function c80001046.indescon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:GetFlagEffect(80001046)==0
end
function c80001046.indesop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	bc:RegisterEffect(e1,true)
end

function c80001046.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
end
function c80001046.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end