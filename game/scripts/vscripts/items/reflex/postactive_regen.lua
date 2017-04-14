LinkLuaModifier( "modifier_item_postactive_regen", "items/reflex/postactive_regen.lua", LUA_MODIFIER_MOTION_NONE )

item_postactive_3c = class({})

function item_postactive_3c:OnSpellStart()
  local caster = self:GetCaster()
  caster:AddNewModifier(caster, self, 'modifier_item_postactive_regen', {
    duration = self:GetSpecialValueFor( "duration" )
  })

  return true
end

modifier_item_postactive_regen = class({})

function modifier_item_postactive_regen:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
  }
end

function modifier_item_postactive_regen:GetModifierConstantHealthRegen()
  return self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
end
