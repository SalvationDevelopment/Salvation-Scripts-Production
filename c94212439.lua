--ウィジャ盤
function c30170982.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--place card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30170982,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetLabel(30170982)
	e2:SetCondition(c30170982.condition)
	e2:SetOperation(c30170982.operation)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c30170982.tgcon)
	e3:SetOperation(c30170982.tgop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(c30170982.tgop)
	c:RegisterEffect(e4)
	--win
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(c30170982.winop)
	c:RegisterEffect(e5)
end
function c30170982.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and e:GetHandler():GetFlagEffect(30170982)<4
end
function c30170982.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local ids={31893528,67287533,94772232,30170981}
	local id=ids[c:GetFlagEffect(30170982)+1]
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(30170982,1))
	local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,id)
	if g:GetCount()>0 and Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		c:RegisterFlagEffect(30170982,RESET_EVENT+0x1fe0000,0,0)
	end
end
function c30170982.cfilter1(c,tp)
	return c:IsControler(tp) and c:IsCode(30170982,31893528,67287533,94772232,30170981)
end
function c30170982.cfilter2(c)
	return c:IsFaceup() and c:IsCode(30170982,31893528,67287533,94772232,30170981)
end
function c30170982.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c30170982.cfilter1,1,nil,tp)
end
function c30170982.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c30170982.cfilter2,tp,LOCATION_ONFIELD,0,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c30170982.cfilter3(c)
	return c:IsFaceup() and c:IsCode(31893528,67287533,94772232,30170981)
end
function c30170982.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_DESTINY_BOARD=0x15
	local g=Duel.GetMatchingGroup(c30170982.cfilter3,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if g:GetClassCount(Card.GetCode)==4 then
		Duel.Win(tp,WIN_REASON_DESTINY_BOARD)
 	end
 end
