--Scripted by Eerie Code
--D/D Baphomet
function c19808608.initial_effect(c)
	--Change Level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19808608,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c19808608.thtg)
	e1:SetOperation(c19808608.thop)
	c:RegisterEffect(e1)
end

function c19808608.thfil(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsSetCard(0xaf)
end
function c19808608.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c19808608.thfil(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c19808608.thfil,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.SelectTarget(tp,c19808608.thfil,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	local t={}
	local i=1
	local p=1
	for i=1,8 do
		t[p]=i
		p=p+1
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19808608,1))
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c19808608.lvfil(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c19808608.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c19808608.lvfil,nil,e)
	local tc=g:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(e:GetLabel())
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c19808608.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c19808608.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xaf)
end