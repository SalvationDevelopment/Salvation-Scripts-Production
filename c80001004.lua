--Performapal Odd-Eyes Unicorn
function c80001004.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80001004,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCondition(c80001004.atkcon)
	e1:SetTarget(c80001004.atktg)
	e1:SetOperation(c80001004.atkop)
	c:RegisterEffect(e1)
	--gain lp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80001004,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c80001004.lptg)
	e2:SetOperation(c80001004.lpop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

function c80001004.filter(c)
	return c:IsSetCard(0x9f) and c:IsFaceup()
end
function c80001004.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(tp) and at:IsSetCard(0x99)
end
function c80001004.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local at=Duel.GetAttacker()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc~=at end
	if chk==0 then return Duel.IsExistingTarget(c80001004.filter,tp,LOCATION_MZONE,0,1,at) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c80001004.filter,tp,LOCATION_MZONE,0,1,1,at)
end
function c80001004.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local at=Duel.GetAttacker()
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetBaseAttack()
	if at:IsFaceup() and at:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		at:RegisterEffect(e1)
	end
end

function c80001004.tgfilter(c)
	return c:IsSetCard(0x9f) and c:IsType(TYPE_MONSTER)
end
function c80001004.lptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:GetControler()==tp and c80001004.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80001004.tgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c80001004.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,g:GetFirst():GetAttack(),1,0,0)
end
function c80001004.lpop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetAttack()
	if tc:IsRelateToEffect(e) then
		Duel.Recover(tp,atk,REASON_EFFECT)
	end
end
