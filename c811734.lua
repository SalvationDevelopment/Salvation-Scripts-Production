--Scripted by Eerie Code
--D/D/D Contract Modification
function c811734.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c811734.condition)
	e1:SetTarget(c811734.target)
	e1:SetOperation(c811734.activate)
	c:RegisterEffect(e1)
end

function c811734.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c811734.filter1(c)
	return c:IsSetCard(0x10af) and c:IsType(TYPE_MONSTER) and c:GetAttack()>0 and c:IsAbleToRemoveAsCost()
end
function c811734.filter2(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xaf) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c811734.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local b1=Duel.IsExistingMatchingCard(c811734.filter1,tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c811734.filter2,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(811734,0),aux.Stringid(811734,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(811734,0))
	else op=Duel.SelectOption(tp,aux.Stringid(811734,1))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_REMOVE)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	end
end
function c811734.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local at=Duel.GetAttacker()
		if at then
			local g=Duel.SelectMatchingCard(tp,c811734.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
			if g:GetCount()>0 then
				local rg=g:GetFirst()
				Duel.Remove(rg,POS_FACEUP,REASON_COST)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(-rg:GetAttack())
				e1:SetReset(RESET_EVENT+0x1fe0000)
				at:RegisterEffect(e1)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c811734.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end