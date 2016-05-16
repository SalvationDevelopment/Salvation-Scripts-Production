--Gendo the Ascetic Monk
function c80001041.initial_effect(c)
	--cannot trigger
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c80001041.target)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(c80001041.con)
	e2:SetValue(aux.tgval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c80001041.con)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end

function c80001041.target(e,c)
	return c:IsPosition(POS_ATTACK)
end

function c80001041.con(e)
	return e:GetHandler():IsDefencePos()
end