--真竜機兵ダースメタトロン
--True Draco Da'at Metatron, the Mechsoldier
--Script by nekrozar
function c57761191.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c57761191.ttcon)
	e1:SetOperation(c57761191.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e2)
	--tribute check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c57761191.valcheck)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c57761191.efilter)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(57761191,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c57761191.spcon)
	e5:SetTarget(c57761191.sptg)
	e5:SetOperation(c57761191.spop)
	c:RegisterEffect(e5)
end
function c57761191.otfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and not c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c57761191.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c57761191.otfilter,tp,LOCATION_ONFIELD,0,nil)
	return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=3)
		or ((not Duel.CheckTribute or Duel.CheckTribute(c,1)) and mg:GetCount()>=2)
		or ((not Duel.CheckTribute or Duel.CheckTribute(c,2)) and mg:GetCount()>=1)
		or ((not Duel.CheckTribute or Duel.CheckTribute(c,3)))
end
function c57761191.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c57761191.otfilter,tp,LOCATION_ONFIELD,0,nil)
	local ct=3
	local g=Group.CreateGroup()
	if Duel.GetTributeCount(c)<ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=mg:Select(tp,ct-Duel.GetTributeCount(c),ct-Duel.GetTributeCount(c),nil)
		g:Merge(g2)
		mg:Sub(g2)
		ct=ct-g2:GetCount()
	end
	if ct>0 and Duel.GetTributeCount(c)>=ct and mg:GetCount()>0
		and Duel.SelectYesNo(tp,aux.Stringid(57761191,0)) then
		local ect=ct
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then ect=ect-1 end
		ect=math.min(mg:GetCount(),ect)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g3=mg:Select(tp,1,ect,nil)
		g:Merge(g3)
		ct=ct-g3:GetCount()
	end
	if ct>0 then
		local g4=Duel.SelectTribute(tp,c,ct,ct)
		g:Merge(g4)
	end
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c57761191.valcheck(e,c)
	local g=c:GetMaterial()
	local typ=0
	local tc=g:GetFirst()
	while tc do
		typ=bit.bor(typ,bit.band(tc:GetOriginalType(),0x7))
		tc=g:GetNext()
	end
	e:SetLabel(typ)
end
function c57761191.efilter(e,te)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
		and te:IsActiveType(e:GetLabelObject():GetLabel()) and te:GetOwner()~=e:GetOwner()
end
function c57761191.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and bit.band(c:GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
end
function c57761191.spfilter(c,e,tp)
	return c:IsAttribute(0xf) and c:IsType(0x802040) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c57761191.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c57761191.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c57761191.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c57761191.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
