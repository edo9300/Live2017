--真竜機士ダイナマイトK
--True Draco Dynamite Knuckle, the Fighter
--Script by nekrozar
function c58984738.initial_effect(c)
	--summon with 1 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(58984738,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c58984738.otcon)
	e1:SetOperation(c58984738.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(58984738,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c58984738.thcon)
	e2:SetTarget(c58984738.thtg)
	e2:SetOperation(c58984738.thop)
	c:RegisterEffect(e2)
end
function c58984738.otfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsReleasable()
end
function c58984738.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:GetLevel()>4 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c58984738.otfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c58984738.otop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(tp,c58984738.otfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c58984738.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE and rp~=tp
end
function c58984738.thfilter(c,tp)
	return (c:IsSetCard(0x1f9) or c:IsCode(30539496,34079868,82321037,87765315,96746083)) and c:GetType()==0x20004
		and (c:IsAbleToHand() or (c:GetActivateEffect():IsActivatable(tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0))
end
function c58984738.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c58984738.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c58984738.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(58984738,3))
	local g=Duel.SelectMatchingCard(tp,c58984738.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:GetActivateEffect():IsActivatable(tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(58984738,2))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
