--Destruction Magician
function c13790536.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c13790536.ptg)
	e2:SetOperation(c13790536.pop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(c13790536.target)
	e3:SetOperation(c13790536.activate)
	c:RegisterEffect(e3)
end
function c13790536.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c13790536.ptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c13790536.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13790536.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c13790536.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c13790536.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(13790536,0))
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		e1:SetTarget(c13790536.sptg)
		e1:SetOperation(c13790536.spop)
		tc:RegisterEffect(e1)
	end
end

function c13790536.filter(c,e,tp)
	local ct=c.xyz_count
	return c:GetRank()==e:GetHandler():GetRank() and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>ct-1 and Duel.IsExistingMatchingCard(c13790536.filter2,tp,LOCATION_MZONE,0,ct-1,nil,e,tp)
end
function c13790536.filter2(c,e,tp)
	return c:GetLevel()==e:GetHandler():GetRank()
end
function c13790536.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_EXTRA) and c13790536.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c13790536.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c13790536.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c13790536.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local ct=tc.xyz_count
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c13790536.filter2,tp,LOCATION_MZONE,0,ct-1,ct-1,nil,e,tp)
		g:AddCard(e:GetHandler())
		local og=e:GetHandler():GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SPSUMMON_PROC)
		e2:SetRange(LOCATION_EXTRA)
		e2:SetOperation(c13790536.xyzop)
		e2:SetReset(RESET_CHAIN)
		e2:SetValue(SUMMON_TYPE_XYZ)
		e2:SetLabelObject(g)
		tc:RegisterEffect(e2)
		Duel.XyzSummon(tp,tc,g)
	end
end
function c13790536.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local mat=e:GetLabelObject()
	c:SetMaterial(mat)
	Duel.Overlay(c,mat)
end

function c13790536.lfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsDisabled()
end
function c13790536.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c13790536.lfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13790536.lfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c13790536.lfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c13790536.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		tc:RegisterEffect(e2)
	end
end
