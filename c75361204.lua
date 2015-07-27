--Scripted by Eerie Code
--Greydle Split
function c75361204.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c75361204.condition)
	e1:SetTarget(c75361204.target)
	e1:SetOperation(c75361204.operation)
	c:RegisterEffect(e1)
end

function c75361204.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c75361204.filter(c)
	return c:IsFaceup()
end
function c75361204.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c75361204.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75361204.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c75361204.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c75361204.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		c:CancelToGrave()
		--Atkup
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		--Equip limit
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(c75361204.eqlimit)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
		--Special Summon
		local e3=Effect.CreateEffect(c)
		e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e3:SetType(EFFECT_TYPE_IGNITION)
		e3:SetRange(LOCATION_SZONE)
		e3:SetCountLimit(1,75361204)
		e3:SetCondition(c75361204.spcon)
		e3:SetCost(c75361204.spcost)
		e3:SetTarget(c75361204.sptg)
		e3:SetOperation(c75361204.spop)
		c:RegisterEffect(e3)
	end
end
function c75361204.eqlimit(e,c)
	return c:GetControler()==e:GetOwnerPlayer()
end

function c75361204.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:GetEquipTarget()
end
function c75361204.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	--Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c75361204.spfilter(c,e,tp)
	return c:IsSetCard(0xd1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75361204.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(c75361204.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and g:GetClassCount(Card.GetCode)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c75361204.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local eq=e:GetHandler():GetEquipTarget()
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	if Duel.Destroy(eq,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(c75361204.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		if g:GetClassCount(Card.GetCode)>=2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg1=g:Select(tp,1,1,nil)
			g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg2=g:Select(tp,1,1,nil)
			sg1:Merge(sg2)
			Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
			sg1:GetFirst():RegisterFlagEffect(75361204,RESET_EVENT+0x1fe0000,0,0,fid)
			sg1:GetNext():RegisterFlagEffect(75361204,RESET_EVENT+0x1fe0000,0,0,fid)
			sg1:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCountLimit(1)
			e1:SetLabel(fid)
			e1:SetLabelObject(sg1)
			e1:SetCondition(c75361204.descon)
			e1:SetOperation(c75361204.desop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c75361204.desfilter(c,fid)
	return c:GetFlagEffectLabel(75361204)==fid
end
function c75361204.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c75361204.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c75361204.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c75361204.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end