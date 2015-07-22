--Fire Force
function c75249652.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c75249652.condition)
	e1:SetTarget(c75249652.target)
	e1:SetOperation(c75249652.activate)
	c:RegisterEffect(e1)
end
function c75249652.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c75249652.filter(c)
	return c:IsAttackPos() and c:IsDestructable()
end
function c75249652.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75249652.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c75249652.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c75249652.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c75249652.filter,tp,0,LOCATION_MZONE,nil)
        if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
		local atk=0
        	local tc=g:GetFirst()
        	while tc do
                        if tc:IsLocation(LOCATION_MZONE)==false and tc:GetTextAttack()>0 then
                		atk=atk+tc:GetTextAttack()
			end
               		tc=g:GetNext()
        	end 
				atk=atk/2
                if atk<0 then atk=0 end
                local val=Duel.Damage(tp,atk,REASON_EFFECT)
		if val>0 and Duel.GetLP(tp)>0 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,val,REASON_EFFECT)
		end
	end
end
