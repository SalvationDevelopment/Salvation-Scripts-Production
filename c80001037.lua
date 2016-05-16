--Ryuu Ookami
function c80001037.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c80001037.tgtg)
	e1:SetOperation(c80001037.tgop)
	c:RegisterEffect(e1)
end

function c80001037.filter(c,sp)
	return c:GetSummonPlayer()==sp
end
function c80001037.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c80001037.filter,1,nil,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c80001037.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
	if tg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local g=tg:Select(1-tp,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end