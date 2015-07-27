--Frightfur Sabre Tiger
function c80889750.initial_effect(c)
	--Fusion material
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c80889750.fscon)
	e1:SetOperation(c80889750.fsop) 
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80889750,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c80889750.spcon)
	e2:SetTarget(c80889750.sptg)
	e2:SetOperation(c80889750.spop)
	c:RegisterEffect(e2)
	--ATK
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xad))
	e3:SetValue(400)
	c:RegisterEffect(e3)
	--Indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetCondition(c80889750.indcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
end

function c80889750.mfilter1(c)
	return c:IsSetCard(0xad) and c:IsType(TYPE_FUSION)
end
function c80889750.mfilter2(c)
	return c:IsSetCard(0xa9) or c:IsSetCard(0xc3)
end
function c80889750.mfilter(c,mg)
	return c80889750.mfilter1(c) and mg:IsExists(c80889750.mfilter2,1,c)
end
function c80889750.fscon(e,mg,gc)
	if mg==nil then return false end
	if gc then return c80889750.mfilter1(gc) and mg:IsExists(c80889750.mfilter2,1,gc) end
	return mg:IsExists(c80889750.mfilter,1,nil,mg)
end
function c80889750.fsop(e,tp,eg,ep,ev,re,r,rp,gc)
	if gc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=eg:FilterSelect(tp,c80889750.mfilter2,1,63,nil)
		Duel.SetFusionMaterial(g1)
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=eg:FilterSelect(tp,c80889750.mfilter,1,1,nil,eg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=eg:FilterSelect(tp,c80889750.mfilter2,1,63,g1:GetFirst())
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end

function c80889750.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c80889750.spfilter(c,e,tp)
	return c:IsSetCard(0xad) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80889750.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c80889750.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsExistingTarget(c80889750.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c80889750.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c80889750.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c80889750.indcon(e)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_FUSION and c:GetMaterialCount()>2
end