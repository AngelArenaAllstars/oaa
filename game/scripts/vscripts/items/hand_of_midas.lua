-- Re-implementation of Hand of Midas because vanilla code doesn't work with multiple levels for whatever reason
-- Code adapted from Angel Arena Blackstar's implementation of Hand of Midas

item_hand_of_midas = class({})

function item_hand_of_midas:GetIntrinsicModifierName()
  return "modifier_item_hand_of_midas"
end

function item_hand_of_midas:OnSpellStart()
  local caster = self:GetCaster()
  local target = self:GetCursorTarget()

  Gold:AddGoldWithMessage(caster, self:GetSpecialValueFor("bonus_gold"))
  if caster.AddExperience then
    caster:AddExperience(target:GetDeathXP() * self:GetSpecialValueFor("xp_multiplier"), false, false)
  end
  EmitSoundOn("DOTA_Item.Hand_Of_Midas", target)
  local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
  ParticleManager:SetParticleControlEnt(midas_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)

  target:SetDeathXP(0)
  target:SetMinimumGoldBounty(0)
  target:SetMaximumGoldBounty(0)
  target:Kill(self, caster)
end

function item_hand_of_midas:IsRefreshable()
  return false
end

item_hand_of_midas_2 = class(item_hand_of_midas)
item_hand_of_midas_3 = class(item_hand_of_midas)
