--Hi-Speedroid Puzzle
function c80001050.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--double atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80001050,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCondition(c80001050.descon)
	e1:SetTarget(c80001050.destg)
	e1:SetOperation(c80001050.desop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c80001050.regcon)
	e2:SetOperation(c80001050.regop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCondition(c80001050.thcon)
	e3:SetTarget(c80001050.thtg)
	e3:SetOperation(c80001050.thop)
	c:RegisterEffect(e3)
end

function c80001050.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bit.band(bc:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c80001050.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,0,0)
end
function c80001050.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(c:GetBaseAttack()*2)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e1)
end

function c80001050.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c80001050.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(80001050,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end

function c80001050.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(80001050)>0
end
function c80001050.filter(c)
	return c:IsSetCard(0x2016) and c:IsType(TYPE_MONSTER) and not c:IsCode(80001050) and c:IsAbleToHand()
end
function c80001050.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c80001050.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80001050.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c80001050.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c80001050.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end