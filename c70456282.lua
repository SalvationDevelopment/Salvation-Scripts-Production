--Scripted by Eerie Code
--Assault Blackwing - Kunai the Drizzle
function c70456282.initial_effect(c)
	--special summon
	--local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(70456282,0))
	--e1:SetType(EFFECT_TYPE_FIELD)
	--e1:SetCode(EFFECT_SPSUMMON_PROC)
	--e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	--e1:SetRange(LOCATION_HAND)
	--e1:SetCondition(c70456282.spcon)
	--e1:SetOperation(c70456282.spop)
	--c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c70456282.spcon)
	e1:SetTarget(c70456282.sptg)
	e1:SetOperation(c70456282.spop)
	c:RegisterEffect(e1)
	--Change level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70456282,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c70456282.lvtg)
	e2:SetOperation(c70456282.lvop)
	c:RegisterEffect(e2)
end

--function c70456282.spcon(e,c)
--  if c==nil then return true end
--  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
--  and Duel.CheckReleaseGroup(c:GetControler(),Card.IsSetCard,1,nil,0x33)
--end
--function c70456282.spop(e,tp,eg,ep,ev,re,r,rp,c)
--  local g=Duel.SelectReleaseGroup(c:GetControler(),Card.IsSetCard,1,1,nil,0x33)
--  Duel.Release(g,REASON_COST)
--  local e1=Effect.CreateEffect(c)
--  e1:SetType(EFFECT_TYPE_SINGLE)
--  e1:SetCode(EFFECT_ADD_TYPE)
--  e1:SetValue(TYPE_TUNER)
--  e1:SetReset(RESET_EVENT+0x1fe0000)
--  c:RegisterEffect(e1)
--end
function c70456282.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(c:GetControler(),Card.IsSetCard,1,nil,0x33)
end
function c70456282.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c70456282.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=Duel.SelectReleaseGroup(c:GetControler(),Card.IsSetCard,1,1,nil,0x33)
	if c:IsRelateToEffect(e) and Duel.Release(g,REASON_COST) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end

function c70456282.thfil(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsType(TYPE_SYNCHRO)
end
function c70456282.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c70456282.thfil(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c70456282.thfil,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.SelectTarget(tp,c70456282.thfil,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	local t={}
	local i=1
	local p=1
	for i=1,8 do
		t[p]=i
		p=p+1
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(70456282,2))
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c70456282.lvfil(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c70456282.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c70456282.lvfil,nil,e)
	local tc=g:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(e:GetLabel())
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end