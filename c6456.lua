--PSYFrame Circuit
function c6456.initial_effect(c)
--Activate
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_ACTIVATE)
        e1:SetCode(EVENT_FREE_CHAIN)
        c:RegisterEffect(e1)
--spsummon
        local e2=Effect.CreateEffect(c)
        e2:SetDescription(aux.Stringid(91110378,0))
        e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
        e2:SetProperty(EFFECT_FLAG_DELAY)
        e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetCondition(c6456.condition)
        e2:SetRange(LOCATION_FZONE)
        e2:SetTarget(c6456.target)
        e2:SetOperation(c6456.operation)
        c:RegisterEffect(e2)
--remove
		local e3=Effect.CreateEffect(c)
		e3:SetCategory(CATEGORY_ATKCHANGE)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e3:SetCode(EVENT_BATTLE_START)
		e3:SetRange(LOCATION_FZONE)
		e3:SetCondition(c6456.condition2)
		e3:SetCost(c6456.cost2)
		e3:SetOperation(c6456.operation2)
		c:RegisterEffect(e3)
end
function c6456.filter(c)
        return c:IsSetCard(0xd3) and c:IsAbleToGraveAsCost() and c:GetAttack()>0
end
function c6456.filter2(c)
        return c:IsSetCard(0xd3) and c:IsFaceup() and c:IsControler(tp)
end
function c6456.condition(e,tp,eg,ep,ev,re,r,rp)
        return eg:IsExists(c6456.filter2,1,nil,tp)
end
function c6456.target(e,tp,eg,ev,re,r,rp,chk)
        if chk==0 then
        local mg=Duel.GetMatchingGroup(c6456.filter2,tp,LOCATION_MZONE,0,nil)
        return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg) end
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c6456.operation(e,tp,eg,ep,ev,re,r,rp)
        if not e:GetHandler():IsRelateToEffect(e) then return end
        local mg=Duel.GetMatchingGroup(c6456.filter2,tp,LOCATION_MZONE,0,nil)
        local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
        if g:GetCount()>0 then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                local sg=g:Select(tp,1,1,nil)
                Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
        end
end
function c6456.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	if not c then return false end
	if c:IsControler(1-tp) then c=Duel.GetAttacker() end
	e:SetLabelObject(c)
	return c and c:IsSetCard(0xd3) and c:IsRelateToBattle()
end
function c6456.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6456.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c6456.filter,tp,LOCATION_HAND,0,1,1,nil,tp)
	local atk=g:GetFirst():GetAttack()
	e:SetLabel(atk)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c6456.operation2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetLabelObject()
	local atk=e:GetLabel()
	if c:IsFaceup() and c:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
	end
end