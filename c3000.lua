--Phantom Knights Rugged Glove
function c3000.initial_effect(c)
        --effect gain
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_BE_MATERIAL)
        e1:SetCondition(c3000.efcon)
        e1:SetOperation(c3000.efop)
        c:RegisterEffect(e1)
        --Dump
        local e2=Effect.CreateEffect(c)
        e2:SetDescription(aux.Stringid(3000,1))
        e2:SetCategory(CATEGORY_TOGRAVE)
        e2:SetType(EFFECT_TYPE_IGNITION)
        e2:SetRange(LOCATION_GRAVE)
        e2:SetCost(c3000.tgcost)
        e2:SetTarget(c3000.tgtg)
        e2:SetOperation(c3000.tgop)
        c:RegisterEffect(e2)
end
function c3000.efcon(e,tp,eg,ep,ev,re,r,rp)
        return r==REASON_XYZ and e:GetHandler():GetAttribute()==ATTRIBUTE_DARK
end
function c3000.efop(e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        local rc=c:GetReasonCard()
        local e1=Effect.CreateEffect(rc)
        e1:SetDescription(aux.Stringid(3000,0))
        e1:SetCategory(CATEGORY_ATKCHANGE)
        e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
        e1:SetCode(EVENT_SPSUMMON_SUCCESS)
        e1:SetCondition(c3000.atkcon)
        e1:SetOperation(c3000.atkop)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        rc:RegisterEffect(e1,true)
        if not rc:IsType(TYPE_EFFECT) then
                local e2=Effect.CreateEffect(c)
                e2:SetType(EFFECT_TYPE_SINGLE)
                e2:SetCode(EFFECT_ADD_TYPE)
                e2:SetValue(TYPE_EFFECT)
                e2:SetReset(RESET_EVENT+0x1fe0000)
                rc:RegisterEffect(e2,true)
        end
end
function c3000.atkcon(e,tp,eg,ep,ev,re,r,rp)
        return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetHandler():GetAttribute()==ATTRIBUTE_DARK
end
function c3000.atkop(e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        if c:IsRelateToEffect(e) and c:IsFaceup() then
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetValue(1000)
                e1:SetReset(RESET_EVENT+0x1ff0000)
                c:RegisterEffect(e1)
        end
end
function c3000.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
        if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
        Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c3000.tgfilter(c)
        return c:IsSetCard(0x13a) and c:IsAbleToGrave()
end
function c3000.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
        if chk==0 then return Duel.IsExistingMatchingCard(c3000.tgfilter,tp,LOCATION_DECK,0,1,nil) end
        Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c3000.tgop(e,tp,eg,ep,ev,re,r,rp)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,c3000.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
                Duel.SendtoGrave(g,REASON_EFFECT)
        end
end